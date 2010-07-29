Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0G2Rx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 13:53:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38315 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752368Ab0G2RxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 13:53:24 -0400
Date: Thu, 29 Jul 2010 19:05:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Simmons <jsimmons@infradead.org>
Cc: Mattia Jona-Lasinio <mattia.jona@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, lcd-linux-users@lists.sourceforge.net
Subject: Re: Introducing the LCD-Linux project
Message-ID: <20100729190515.6ec85db2@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1007291659400.16616@casper.infradead.org>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
	<20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk>
	<AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com>
	<AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
	<loom.20100724T155117-833@post.gmane.org>
	<AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com>
	<AANLkTimHQ5DoqXikCu7=Nse16axKYYTJZEBJsSxFEH2y@mail.gmail.com>
	<20100728203921.0dd6562d@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1007291659400.16616@casper.infradead.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 3) Invert the VT layer. Currently the console/printk driver is on top of
>    the tty layer. It would be nice to be able to only use a very light 
>    weight vt printk without the VT tty on top for embedded platforms.

No. printk hits console drivers why may or may not be frame buffer
interfaces. Has done for a very long time. Keith Packard has also been
doing stuff with crash time oops displays etc over an X display.
 
> 4) Seperate out the VT emulation layer. Related to 3.

Separate from what ?

> 5) Multiple independent VT support. Which brings up the question what 
>    should the mapping of VCs to a VT look like. 

I would suggest we borrow the X idea and each VC is

	int display;	/* Display it is on (for console flipping) */
	struct something *vt;	/* VT which it is displaying */
	int x,y,w,h;	/* Window onto vt */

