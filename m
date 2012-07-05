Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2GEHwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:52:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38432 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab2GEHwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:52:14 -0400
Date: Thu, 5 Jul 2012 08:52:04 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: Re: linux-next: manual merge of the signal tree with the
	arm-current tree
Message-ID: <20120705075204.GA12344@flint.arm.linux.org.uk>
References: <20120705173526.bf8772adb18edfc91adddea8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705173526.bf8772adb18edfc91adddea8@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 05:35:26PM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the signal tree got a conflict in
> arch/arm/kernel/signal.c between commit f73e2ca64281 ("ARM: 7443/1:
> Revert "new way of handling ERESTART_RESTARTBLOCK"") from the arm-current
> tree and commits 9c802c169f96 ("arm: deal with handlerless restarts
> without leaving the kernel") and 76c3f4da3ee4 ("arm: get rid of
> TIF_SYSCALL_RESTARTSYS") from the signal tree.
> 
> I have no idea how to cope with this.  So I have effectively reverted
> commit f73e2ca64281 ("ARM: 7443/1: Revert "new way of handling
> ERESTART_RESTARTBLOCK"") for today (though parts of that commit are also
> implemented by the above signal tree commits).

Currently, bugs have been found with the signal handling updates which
happened during the last merge window.

Will has concerns with Al's proposed fixes for the signal handling.
Unfortunately, Al isn't responding to attempts to discuss this (for
whatever reason), and as we're now at -rc5, we believe Al's patches are
now too complex to go into this stage of -rc.

We have had to find a way forward on this - which means reverting some
of the commits that went in during the previous merge window.

So, your revert to "fix" this isn't a good idea, because it isn't what
will be going to Linus this weekend.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
