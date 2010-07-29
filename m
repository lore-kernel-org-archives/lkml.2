Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab0G2Sjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 14:39:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:59499 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab0G2Sjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 14:39:31 -0400
Date: Thu, 29 Jul 2010 19:39:22 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Mattia Jona-Lasinio <mattia.jona@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, lcd-linux-users@lists.sourceforge.net
Subject: Re: Introducing the LCD-Linux project
In-Reply-To: <20100729190515.6ec85db2@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1007291934310.16616@casper.infradead.org>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com> <20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk> <AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com> <AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
 <loom.20100724T155117-833@post.gmane.org> <AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com> <AANLkTimHQ5DoqXikCu7=Nse16axKYYTJZEBJsSxFEH2y@mail.gmail.com> <20100728203921.0dd6562d@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1007291659400.16616@casper.infradead.org>
 <20100729190515.6ec85db2@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 3) Invert the VT layer. Currently the console/printk driver is on top of
> >    the tty layer. It would be nice to be able to only use a very light 
> >    weight vt printk without the VT tty on top for embedded platforms.
> 
> No. printk hits console drivers why may or may not be frame buffer
> interfaces. Has done for a very long time. Keith Packard has also been
> doing stuff with crash time oops displays etc over an X display.

Correct. What I mean is have the ability to just register the console 
driver but not the tty driver.
  
> > 4) Seperate out the VT emulation layer. Related to 3.
> 
> Separate from what ?

We can still have a basic tty layer without the control characters, think 
do_con_trol in vt.c, junk compiled into the kernel. Make it a options for 
userland to do the vt100 emulation.

> > 5) Multiple independent VT support. Which brings up the question what 
> >    should the mapping of VCs to a VT look like. 
> 
> I would suggest we borrow the X idea and each VC is
> 
> 	int display;	/* Display it is on (for console flipping) */
> 	struct something *vt;	/* VT which it is displaying */
> 	int x,y,w,h;	/* Window onto vt */

/dev/tty[0-16]  -> VT display 0
/dev/tty[17-31] -> VT display 1

etc.

At least that is how I handled it  several years ago.

