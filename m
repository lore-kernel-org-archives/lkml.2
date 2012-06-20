Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab2FTWXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:23:50 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18732 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab2FTWXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:23:48 -0400
Date: Thu, 21 Jun 2012 00:23:47 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Paul Bolle <pebolle@tiscali.nl>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jeff Epler <jepler@inetnebr.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Remove ancient dead code
In-Reply-To: <1340230589.1773.7.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1206210022130.7671@swampdragon.chaosbits.net>
References: <1340230589.1773.7.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, Paul Bolle wrote:

> Release v1.3.82 wrapped a few lines of code in an "#ifdef
> SAFE_RESET_DISK_CONTROLLER" and "#endif" pair. Since
> SAFE_RESET_DISK_CONTROLLER was never defined anywhere that was basically
> a verbose "#ifdef 0" and "#endif" pair. These dead lines have been in
> the tree for sixteen years but now the time has come to remove them.
> 
> I guess the main lesson here is that if you want your dead code in the
> tree for a very long time you'd better be creative. A plain old "#ifdef
> 0" and "#endif" pair just doesn't cut it!
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> Link: https://lkml.org/lkml/1996/3/30/38
> Cc: Jeff Epler <jepler@inetnebr.com>
> ---
>  arch/x86/boot/header.S |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
> index efe5acf..9b9c647 100644
> --- a/arch/x86/boot/header.S
> +++ b/arch/x86/boot/header.S
> @@ -406,13 +406,6 @@ init_size:		.long INIT_SIZE		# kernel initialization size
>  
>  	.section ".entrytext", "ax"
>  start_of_setup:
> -#ifdef SAFE_RESET_DISK_CONTROLLER
> -# Reset the disk controller.
> -	movw	$0x0000, %ax		# Reset disk controller
> -	movb	$0x80, %dl		# All disks
> -	int	$0x13
> -#endif
> -
>  # Force %es = %ds
>  	movw	%ds, %ax
>  	movw	%ax, %es
> 
Looks good to me.
Not that I have much knowledge of the code, but I did dig the history a 
bit and yes, this looks like long dead stuff that should just go away.

Acked-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

