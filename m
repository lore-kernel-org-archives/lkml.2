Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0KGVYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:24:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63130 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0KGVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=rTk+F3s0tlNdAcrp5QFk87SYS0PpHaEaH3Eih/WAXGcUlkwGJdpKxh1xb0wsyNB63X
         49h7FruzOPLeNN2uToR1Ff7QWjKYQv83Y2b30jqHS5Yqqu827OIFxBLzJsXQJBVbj7yt
         uRaM4Skz4+bIn86n6lxi3/Sfd1nzVXJtYqcOs=
Date: Sun, 7 Nov 2010 22:24:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?S=F8ren?= Sandmann Pedersen <ssp@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: Eliminate bp argument from the stack tracing
	routines
Message-ID: <20101107212412.GB11134@nowhere>
References: <ye8ljj3mlj5.fsf@camel16.daimi.au.dk> <1288955674-2744-1-git-send-email-ssp@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288955674-2744-1-git-send-email-ssp@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 07:14:33AM -0400, Søren Sandmann Pedersen wrote:
> Hi,
> 
> This is a resurrection of an old patch that I sent about a year ago:
> 
>      http://lkml.org/lkml/2009/10/22/192
> 
> At the time, I thought the patch broke perf callchains on 64 bit, but
> it turns out that those are broken even without this patch. 
> 
> I don't know why that is, but I now think the patch is correct and to
> blame.
> 
> (FWIW, this
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 461a85d..d977d26 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1653,7 +1653,7 @@ static const struct stacktrace_ops backtrace_ops = {
>  	.warning_symbol		= backtrace_warning_symbol,
>  	.stack			= backtrace_stack,
>  	.address		= backtrace_address,
> -	.walk_stack		= print_context_stack_bp,
> +	.walk_stack		= print_context_stack,
>  };
> 
> makes it produce correct kernel callchains. And yes, I did compile the
> kernel with CONFIG_FRAME_POINTER).



What do you see is broken in 64 bits perf callchains? Can you please provide
me more details so that I can fix the issue?

Thanks.

