Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab0G2Qtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:49:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:51874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab0G2Qti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:49:38 -0400
Date: Thu, 29 Jul 2010 17:49:31 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Mattia Jona-Lasinio <mattia.jona@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, lcd-linux-users@lists.sourceforge.net
Subject: Re: Introducing the LCD-Linux project
In-Reply-To: <20100728203921.0dd6562d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1007291659400.16616@casper.infradead.org>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com> <20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk> <AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com> <AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
 <loom.20100724T155117-833@post.gmane.org> <AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com> <AANLkTimHQ5DoqXikCu7=Nse16axKYYTJZEBJsSxFEH2y@mail.gmail.com> <20100728203921.0dd6562d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > was born. Implementing this  in the standard Linux terminal emulation
> > would require
> > a rewrite of most of the code, which I personally would do only if
> > there is some interest from
> > the community in improving the standard Linux console
> 
> There is a great deal of interest. Most of the console (as in
> framebuffer) activity moved to the 3D direct rendering world some time
> ago.

Really. I didn't expect the console to be of much interest.
 
> Let's start at the beginning. What console layer things need fixing to
> make the LCD Linux project able to use them ?
> 
> Multiple displays live at once is an obvious one - the 3D graphics folks
> also want some of that too.

Okay you asked for it. 

1) To do multiple displays will require the console tool updates.

2) Kill the big ugly console lock. One lock for not only multiple 
   VTs but even multiple types of consoles is horrible. I seen on 
   embedded board using the framebuffer device take the console
   lock thus block the serial port.

3) Invert the VT layer. Currently the console/printk driver is on top of
   the tty layer. It would be nice to be able to only use a very light 
   weight vt printk without the VT tty on top for embedded platforms.

4) Seperate out the VT emulation layer. Related to 3.

5) Multiple independent VT support. Which brings up the question what 
   should the mapping of VCs to a VT look like. 

6) A nice scrollback buffer on the VT layer level instead of the hacks we 
   have in fbcon and vgacon.

