Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab2JYPzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:55:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46954 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2JYPzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:55:18 -0400
Date: Thu, 25 Oct 2012 16:55:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] openrisc: move sys_clone's stack determination to
 copy_thread
Message-ID: <20121025155516.GL2616@ZenIV.linux.org.uk>
References: <1351179999-8376-1-git-send-email-jonas@southpole.se>
 <1351179999-8376-2-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351179999-8376-2-git-send-email-jonas@southpole.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 05:46:38PM +0200, Jonas Bonn wrote:
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
>  arch/openrisc/kernel/process.c  |    6 +++++-
>  arch/openrisc/kernel/sys_or32.c |    8 +-------
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
> index e0874b8..efbe4f8 100644
> --- a/arch/openrisc/kernel/process.c
> +++ b/arch/openrisc/kernel/process.c
> @@ -170,7 +170,11 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
>  	} else {
>  		*userregs = *regs;
>  
> -		userregs->sp = usp;
> +		if (usp)
> +			userregs->sp = usp;		/* clone */

OK

> +		else
> +			userregs->sp = regs->sp;	/* fork/clone */

What for?  userregs->sp will be equal to regs->sp at that point, unless
your compiler is very badly broken.  You've copied *regs to *userregs
wholesale, just above that if...
