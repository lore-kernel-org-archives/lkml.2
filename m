Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0KWNHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:07:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:50719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab0KWNHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:07:07 -0500
Subject: Re: How about limiting refresh ioctl to sampling events ?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <m3zkt05h3w.fsf@gmail.com>
References: <m3zkt05h3w.fsf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 14:07:26 +0100
Message-ID: <1290517646.2072.403.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 14:01 +0100, Franck Bui-Huu wrote:
> Hello Peter,
> 
> I'm looking at the perf event stuff and wondering if
> perf_event_refresh() should be limited to sampling events.
> 
> Does the following make sense ?
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 3b105e0..1a90a6c 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1072,7 +1072,7 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
>  	/*
>  	 * not supported on inherited events
>  	 */
> -	if (event->attr.inherit)
> +	if (event->attr.inherit || !event->attr.sample_period)
>  		return -EINVAL;
>  
>  	atomic_add(refresh, &event->event_limit);

Yes it does, please submit as a proper patch.
