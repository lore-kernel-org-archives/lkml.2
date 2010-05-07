Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab0EGPmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:42:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:33616 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0EGPl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:41:59 -0400
Subject: Re: [PATCH] perf: fix raw sample size if no sampling data is
 attached
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100507152835.GU6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271190201-25705-13-git-send-email-robert.richter@amd.com>
	 <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
	 <20100507152835.GU6450@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 17:41:54 +0200
Message-ID: <1273246914.1642.359.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 17:28 +0200, Robert Richter wrote:
> From 6373951f1c660400650066b73c3bb2f6d232be67 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Fri, 7 May 2010 15:49:56 +0200
> Subject: [PATCH] perf: fix raw sample size if no sampling data is
> attached
> 
> The header size of a raw sample is not included in the total size of a
> raw data sample. Thus, if no data is attached the size must be
> null. In this case a buffer overflow may occur when copying the
> sampling data.
> 
But there is data, a whole u32 of value 0. Your patch breaks things.

> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  kernel/perf_event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 9dbe8cd..f6ddae9 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -3229,7 +3229,7 @@ void perf_output_sample(struct
> perf_output_handle *handle,
>                                 u32     size;
>                                 u32     data;
>                         } raw = {
> -                               .size = sizeof(u32),
> +                               .size = 0,
>                                 .data = 0,
>                         };
>                         perf_output_put(handle, raw); 



