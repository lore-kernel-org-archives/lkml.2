Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1CJXCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:02:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37804 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1CJXCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:02:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=McBs73iL+38/qFxLWUqQJd30HzQWNZOETVwCluo1XupGVft6zT6MzFsNt1qmmzqujy
         wInDDvO7uLSLWKTbL+SkTEb8/CUUPO7LlHFO+lkwxHaVpLuDJNn/cp+9KUt/MHFHsDbh
         eWGnpU70qH0DBjlwBa9IUboLQFOVd2MQchcvo=
Date: Fri, 11 Mar 2011 00:02:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, namhyung@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86, dumpstack: Use frame pointer during
 stack trace
Message-ID: <20110310230222.GB1837@nowhere>
References: <1299584662-24421-4-git-send-email-namhyung@gmail.com>
 <tip-2f8058ae197236f9d5641850ce27f67d8f3e0b39@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-2f8058ae197236f9d5641850ce27f67d8f3e0b39@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 10:26:07PM +0000, tip-bot for Namhyung Kim wrote:
> Commit-ID:  2f8058ae197236f9d5641850ce27f67d8f3e0b39
> Gitweb:     http://git.kernel.org/tip/2f8058ae197236f9d5641850ce27f67d8f3e0b39
> Author:     Namhyung Kim <namhyung@gmail.com>
> AuthorDate: Tue, 8 Mar 2011 20:44:22 +0900
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 10 Mar 2011 23:20:30 +0100
> 
> x86, dumpstack: Use frame pointer during stack trace
> 
> If CONFIG_FRAME_POINTER is set then use the frame pointer for the
> stack backtrace rather than scanning whole stack blindly.

We don't do it blindly, we actually check the reliability with the
frame pointer.

I'm not sure this patch is a good idea. stack dumps need to stay very
robust and not exclusively rely on the frame pointer to be correct.
At least walking blindly the stack provides a best effort dump as a last
resort.


> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <1299584662-24421-4-git-send-email-namhyung@gmail.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/dumpstack.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 38b74a5e..56db27d 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -170,7 +170,11 @@ static const struct stacktrace_ops print_trace_ops = {
>  	.warning_symbol		= print_trace_warning_symbol,
>  	.stack			= print_trace_stack,
>  	.address		= print_trace_address,
> +#ifdef CONFIG_FRAME_POINTER
> +	.walk_stack		= walk_context_stack_bp,
> +#else
>  	.walk_stack		= walk_context_stack,
> +#endif
>  };
