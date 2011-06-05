Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1FEVbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 17:31:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42428 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab1FEVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 17:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mZkKrOCQavhezXF4EUImX+570e/jnXKj1PCQaFsAFQExgTSP7AT+PNeacyu7BFH1W2
         EkdiC/ndb6vFsbyD96CpcgHlv5ghlVx9niYw3ovEsqeZQHjLk3KikIAmgSsmeRtjWwuW
         Hx+b+/K8M8rpUe7aDqrCvcY/uJ95alW6MPATM=
Date: Sun, 5 Jun 2011 23:31:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide
 debug options
Message-ID: <20110605213115.GA7862@somewhere>
References: <20110605210223.GA7595@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605210223.GA7595@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 02:02:25PM -0700, Josh Triplett wrote:
> Several debugging options currently default to y, such as
> CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users might
> want to turn those options off to save space; however, turning them off
> requires turning on CONFIG_DEBUG_KERNEL to unhide them.  Since
> CONFIG_DEBUG_KERNEL exists specifically to unhide debugging options, and
> CONFIG_EXPERT exists specifically to unhide options potentially needed
> by experts and/or embedded users, make CONFIG_EXPERT automatically imply
> CONFIG_DEBUG_KERNEL.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> Revised as requested by Ingo Molnar.
> 
>  init/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index ebafac4..5e482a3 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -909,6 +909,7 @@ config ANON_INODES
>  
>  menuconfig EXPERT
>  	bool "Configure standard kernel features (expert users)"
> +	select DEBUG_KERNEL

Please add a quick comment that explains the reason for that select. Because
without that changelog, it's very non obvious.

Thanks.

>  	help
>  	  This option allows certain base kernel options and settings
>            to be disabled or tweaked. This is for specialized
> -- 
> 1.7.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
