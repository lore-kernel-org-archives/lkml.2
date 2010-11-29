Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0K2Xo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:44:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48202 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751359Ab0K2XoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:44:25 -0500
Date: Mon, 29 Nov 2010 23:42:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, sodaville@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
Message-ID: <20101129234259.586eb27a@lxorguk.ukuu.org.uk>
In-Reply-To: <4CF40DF4.9060204@firmworks.com>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	<1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
	<1290808645.32570.158.camel@pasglop>
	<20101128160449.GC30784@www.tglx.de>
	<1290984809.32570.208.camel@pasglop>
	<20101129130720.7d060e1c@udp111988uds.am.freescale.net>
	<1291061128.32570.298.camel@pasglop>
	<4CF40DF4.9060204@firmworks.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The usual layout is that the PCI bus is a direct child of
> the root node, and the ISA bus is a child of the PCI bus.
> That reflects the "Northbridge + Southbridge" wiring that

That isn't strictly true either. On many PC devices the ISA bus (or LPC
bus nowdays) has no heirarchy as such because ISA cycles get issued if
the PCI cycles don't generate a response. In addition some cycles go to
both busses on some chipsets and there are various bits of magic so the
I/O spaces and particularly the memory spaces are intertwined.

So it's not a subordinate bus really, its a bit weirder. PCMCIA is
probably a sub-bus when you've got a PCI/PCMCIA adapter but ISA in
general is a bit fuzzy.

And then there are systems like PA-RISC where there are multiple entire
PCI/ISA busses hung off the primary bus which is neither 8)

There are also various bits of "architectural" space which are on the
motherboard (traditionally 0x00-0xFF) but some of which are on the CPU in
some cases (Cyrix was 0x21/22 if I remember), and there are other
architectural spaces like the ELCR which are "magic".

The PC is alas to computer architecture what perl is to programming
languages.

Alan
