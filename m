Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2GJPRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:17:35 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56933 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2GJPRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:17:33 -0400
Date: Tue, 10 Jul 2012 16:20:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andy Green (=?UTF-8?B?5p6X5a6J5bu4?=)" <andy@warmcat.com>
Cc: Florian Fainelli <florian@openwrt.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        s-jan@ti.com, arnd@arndb.de, patches@linaro.org, tony@atomide.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [PATCH 4 0/4] Add ability to set defaultless network device MAC
 addresses to deterministic computed locally administered values
Message-ID: <20120710162026.71534607@pyramind.ukuu.org.uk>
In-Reply-To: <4FFC2712.9020208@warmcat.com>
References: <20120705024259.26317.16000.stgit@build.warmcat.com>
	<201207101437.54877.florian@openwrt.org>
	<4FFC2712.9020208@warmcat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why should Ubuntu, Fedora etc stink up their OSes with Panda-specific 
> workarounds?  And Panda is not the only device with this issue.

Why should we crap all over the kernel for all these board specific
problems ? Userspace code is at least pageable and generally less
security critical.

So your argument from that point of view is bunk. There are tons and tons
of boards doing tons of horrible hacks. If we mangled the generic code
for all of them the result would be a complete unmanagable pile of turd.

The use of locally administered MAC addressing is policy. The helper
belongs in userspace as it's clearly part of what udev is supposed to be
doing via device notifications, instead of your custom mini kernel-udev
hack which is what you've basically created.

We've said no to lots of people (several a year). We've done so for good
reasons. Most of them had more taste than your hack too (ok except the Pi
which was even more broken)

You need a udev rule, one single tiddly udev rule, and perhaps to expose a
sysfs node somewhere if the required generation data is on the board.
Hardly stinking up the userspace is it.

That would also then fix any races with userspace trying to set the MAC,
it would remove the need for the helper. It will avoid encoding
ultra-crappy assumptions like

"To make use of this safely you also need to make sure that any drivers
that may compete for the bus ordinal you are using (eg, mUSB and ehci in
Panda case) are loaded in a deterministic order."

What are you going to do when speeding up booting by parallelising
more probes breaks this kind of garbage assumption ?

To be honest if Fedora needs to deal with an army of craptastic devices
whose vendors can't get a MAC address on the board then they probably
need a single common change to ifup so that if you ifup an interface that
has no MAC it generates a local one. Thats about 6 lines of userspace
code in the config scripts. It's also probably a good default end user
behaviour.

And if you have a real MAC but it's not loaded into the device you can
just shove it into the platform device.

End of problem.

Alan
