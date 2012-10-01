Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2JACxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 22:53:11 -0400
Received: from www.xplot.org ([66.92.66.146]:53837 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2JACxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 22:53:09 -0400
X-Greylist: delayed 1880 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2012 22:53:09 EDT
From: Tim Shepard <shep@alum.mit.edu>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_EXPERT is a booby trap
Date: Sun, 30 Sep 2012 22:21:45 -0400
Message-Id: <E1TIVdh-0007iT-00@www.xplot.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



A month or two ago when I attempted to upgrade from 3.4 to 3.5 on my
MacBook Pro laptop, in preparation to try an interesting patch to TCP
developed against 3.5 by a colleague, my keyboard stopped working.  I
tried bisecting, but that lead to nowhere useful and much confusion.


It turns out that while I was looking for some debug options under
"General setup" and "Kernel hacking", I turned on "Configure standard
kernel features (expert users)" which is also known as CONFIG_EXPERT.
I read the documentation for that option, and I perused the options
which appeared underneath when it was turned on, thought to myself "oh,
hmm, I don't want to change any of these" and wandered off and
eventually found what I was actually looking for elsewhere in the
kernel configuration tree.

This weekend I finally figured out why the keyboard in my MacBook Pro
stopped working between 3.4 and 3.5.

When I turned on CONFIG_EXPERT it turned off CONFIG_HID_APPLE.  There
was no warning that selecting "Configure standard kernel features" will
invisibly turn off needed things elsewhere in the configuration tree.

Something needs to be fixed, but it's not obvious that any simple change
will work without causing other troubles.

I've read some of the lkml history history and learned that references
to CONFIG_EXPERT (like the one on CONFIG_HID_APPLE) used to be
references to CONFIG_EMBEDDED, so CONFIG_EXPERT used to mean something
else.

Maybe "make menuconfig" should show you all the things that you've just
changed and ask for confirmation when changing one configuration option
causes actual configuration changes elsewhere in the tree.

And may I suggest that CONFIG_EXPERT should be factored into two
CONFIGs, one of which makes configuration things visible, and another
which changes the default values to something more appropriate for
embedded systems (perhaps call it CONFIG_EMBEDDED_DEFAULTS).  That way
you'd have to select CONFIG_EXPERT, and then select the
CONFIG_EMBEDDED_DEFAULTS option that CONFIG_EXPERT made visible to
actually change any configuration, and the documentation for
CONFIG_EMBEDDED_DEFAULTS could explain that it changes defaults
throughout the tree (and selecting CONFIG_EXPERT alone would not go off
and muck things up with no warning).

The transition plan such a factoring needs some further thought to avoid
breaking anyone's current configuration when they "make oldconfig".


			-Tim Shepard
			 shep@alum.mit.edu
