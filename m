Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0EGTst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:48:49 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:18327
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932167Ab0EGTsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:48:47 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lab9bhzz1202hzz6ff19hz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L22F0X-01-48N-02
X-M-MSG: 
Date: Fri, 7 May 2010 21:48:33 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: fix raw sample size if no sampling data is
 attached
Message-ID: <20100507194833.GY6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-13-git-send-email-robert.richter@amd.com>
 <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
 <20100507152835.GU6450@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100507152835.GU6450@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.10 17:28:35, Robert Richter wrote:
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 9dbe8cd..f6ddae9 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -3229,7 +3229,7 @@ void perf_output_sample(struct perf_output_handle *handle,
>  				u32	size;
>  				u32	data;
>  			} raw = {
> -				.size = sizeof(u32),
> +				.size = 0,
>  				.data = 0,

Uhhh, this padding data was completly hidden to me by a SEP field. It
became visible to me with a far distance of at least 4km and only from
the corner of my eye. So, *now* I realized that size is the size of
padding data, not the size header! Please ignore this, I shouln't send
patches at Friday afternoon.

-Robert

>  			};
>  			perf_output_put(handle, raw);

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

