Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3ABKQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 05:16:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38589 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3ABKQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 05:16:12 -0500
Date: Wed, 2 Jan 2013 10:15:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Dan Carpenter <error27@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of
	IS_ERR_OR_NULL
Message-ID: <20130102101554.GD2631@n2100.arm.linux.org.uk>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-7-git-send-email-linux@prisktech.co.nz> <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com> <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com> <20130102092638.GB2631@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1301021031490.1994@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1301021031490.1994@hadrien>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 10:44:32AM +0100, Julia Lawall wrote:
> On Wed, 2 Jan 2013, Russell King - ARM Linux wrote:
> 
> > On Wed, Jan 02, 2013 at 08:10:36AM +0300, Dan Carpenter wrote:
> > > clk_get() returns NULL if CONFIG_HAVE_CLK is disabled.
> > >
> > > I told Tony about this but everyone has been gone with end of year
> > > holidays so it hasn't been addressed.
> > >
> > > Tony, please fix it so people don't apply these patches until
> > > clk_get() is updated to not return NULL.  It sucks to have to revert
> > > patches.
> >
> > How about people stop using IS_ERR_OR_NULL for stuff which it shouldn't
> > be used for?
> 
> Perhaps the cases where clk_get returns NULL could have a comment
> indicating that NULL does not represent a failure?

No.  More documentation is never the answer to people not reading
existing documentation.

> In 3.7.1, it looks like it might have been possible for NULL to be
> returned by clk_get in arch/mips/loongson1/common/clock.c, but that
> definition seems to be gone in a recent linux-next.  The remaining
> definitions look OK.

How about people just read the API and comply with it rather than
doing their own thing all the time?  We've already had at least one
instance where someone has tried using IS_ERR() with the ioremap()
return value.

Really, if you're going to program kernel space, it is very important
that you *know* the interfaces that you're using and you comply with
them.  Otherwise, you have no business saying that you're a kernel
programmer.

Yes, the odd mistake happens, but that's no excuse for the constant
blatent mistakes with stuff like IS_ERR_OR_NULL() with clk_get()
which just comes from total laziness on the part of the coder to
understand the interfaces being used.  Hell, it's even documented
in linux/clk.h - that just shows how many people read the
documentation which has been around since the clk API came about.
