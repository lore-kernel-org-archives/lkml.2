Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab0JQTX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 15:23:59 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44223 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab0JQTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 15:23:58 -0400
Message-ID: <4CBB4D4F.8010904@cs.helsinki.fi>
Date: Sun, 17 Oct 2010 22:23:59 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, arjan@linux.intel.com,
        peterz@infradead.org
Subject: Re: [PATCH 1/1] um: fix global timer issue when using CONFIG_NO_HZ
References: <1287242638-20968-1-git-send-email-richard@nod.at>
In-Reply-To: <1287242638-20968-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.10.2010 18.23, Richard Weinberger wrote:
> This fixes a issue which was introduced by fe2cc53e.
> timeval_to_ns() returns long long and not int.
> Due to that UML's timer did not work proper and caused timer freezes.
>
> LKML-Reference:<AANLkTik5_TCXeGzTWBZzE8F0Cb2bQq-D228xDXk87rhP () mail ! gmail ! com>
> Signed-off-by: Richard Weinberger<richard@nod.at>
> ---
>   arch/um/os-Linux/time.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
> index dec5678..6e3359d 100644
> --- a/arch/um/os-Linux/time.c
> +++ b/arch/um/os-Linux/time.c
> @@ -60,7 +60,7 @@ static inline long long timeval_to_ns(const struct timeval *tv)
>   long long disable_timer(void)
>   {
>   	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
> -	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
> +	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
>
>   	if (setitimer(ITIMER_VIRTUAL,&time,&time)<  0)
>   		printk(UM_KERN_ERR "disable_timer - setitimer failed, "

Acked-by: Pekka Enberg <penberg@kernel.org>
