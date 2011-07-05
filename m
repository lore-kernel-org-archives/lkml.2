Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab1GEKvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:51:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:51960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab1GEKvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:51:35 -0400
Subject: Re: [PATCH] perf: Extend attr check to allow also dynamically
 generated
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110705094714.GA4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
	 <1309716271.3282.6.camel@twins> <20110704175927.GZ4590@erda.amd.com>
	 <20110705094714.GA4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 12:51:00 +0200
Message-ID: <1309863060.3282.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 11:47 +0200, Robert Richter wrote:

> From 63e76c3d827e3d6d24ff4ee24854523c054c7179 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Tue, 5 Jul 2011 11:04:39 +0200
> Subject: [PATCH] perf: Extend attr check to allow also dynamically generated
>  types
> 
> When attaching events to a pmu with generated type, the initialization
> fails. Extending the check to allow such types.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  kernel/events/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index cca3588..5900729 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5958,7 +5958,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
>  	 * If the type exists, the corresponding creation will verify
>  	 * the attr->config.
>  	 */
> -	if (attr->type >= PERF_TYPE_MAX)
> +	if (attr->type >= PERF_TYPE_MAX && !idr_find(&pmu_idr, attr->type))
>  		return -EINVAL;
>  
>  	if (attr->__reserved_1)

Lin Ming submitted a similar patch:

 http://marc.info/?l=linux-kernel&m=130942109729864

Which I prefer as it removes code. Event creation will fail in
perf_init_event() in that case when an invalid type is specified.
