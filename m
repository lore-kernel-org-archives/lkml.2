Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab0K3NPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 08:15:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36853 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0K3NPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 08:15:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GYk3P+/LcRQoN6ESJxrsH2lJRgDy0sD+yYzS5zrNmQ1fRcoMnmb+ihEidbgwDKHg0W
         fAhQxsbyscdiMQ6ycaIjLBa2I355DWY9X2Zhgs5ku62+5EctYJ/wj9zHtMOE1pFYUTYR
         msazodqHSX5PeDROGGfr1b9AFgUN47p4et3ek=
Date: Tue, 30 Nov 2010 16:15:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com, yinghai@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, NMI: add back unknown_nmi_panic and
	nmi_watchdog sysctls
Message-ID: <20101130131517.GA16372@lenovo>
References: <1291068437-5331-1-git-send-email-dzickus@redhat.com> <1291068437-5331-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291068437-5331-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 05:07:17PM -0500, Don Zickus wrote:
> Originally adapted from Huang Ying's patch which moved the unknown_nmi_panic
> to the traps.c file.  Because the old nmi watchdog was deleted before this
> change happened, the unknown_nmi_panic sysctl was lost.  This re-adds it.
> 
> Also, the nmi_watchdog sysctl was re-implemented and its documentation
> updated accordingly.
> 
> Patch-inspired-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>

(a 'thing' below which could be addressed later)
...
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index d91b07d..140344d 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -733,6 +733,22 @@ static struct ctl_table kern_table[] = {
>  		.extra1		= &zero,
>  		.extra2		= &one,
>  	},
> +	{
> +		.procname       = "nmi_watchdog",
> +		.data           = &watchdog_enabled,
> +		.maxlen         = sizeof (int),
> +		.mode           = 0644,
> +		.proc_handler   = proc_dowatchdog_enabled,
> +	},
> +#endif
> +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)

This kinda wonders me -- do we have CONFIG_X86_LOCAL_APIC set _without_
CONFIG_X86? I mean CONFIG_X86_LOCAL_APIC is per x86, no?

  Cyrill
