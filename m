Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2LQSWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:22:16 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59486 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab2LQSWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:22:14 -0500
Subject: [PATCH 0/7] Put "Kernel hacking" Kconfig menu on a diet
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-arch@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 17 Dec 2012 13:22:06 -0500
Message-Id: <20121217182206.91AA150A@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121718-9360-0000-0000-00000E10B1CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the "Kernel Hacking" menu has gotten a bit out of hand.  It
is over 120 lines long on my system with everything enabled and
options are scattered around it haphazardly.

	http://sr71.net/~dave/linux/kconfig-horror.png

Let's try to introduce some sanity.

I believe the risk of a series like this is pretty low, so I'd like
to see these make it in to 3.8 if there are no major objections.

This set stands on its own, but there is plenty of room for follow-up
patches.  The arch-specific debug options still end up getting stuck
in the top-level "kernel hacking" menu.  OPTIMIZE_INLINING, for
instance, could obviously go in to the "compiler options" menu, but
the fact that it is defined in arch/ in a separate Kconfig file keeps
it on its own.

Any thoughts on how we could address this going forward?

1. Define all arch-specific debugging options in lib/Kconfig.debug
   Have the architectures 'select' them.

2. Introduce some Kconfig language changes that allow menu
   position to be specified independently of where the "config"
   text occurs, like an "appears_in":

config DEBUG_INFO
	bool "Compile the kernel with debug info"
	depends on DEBUG_KERNEL
	appears_in "Kernel Hacking/Compiler Options"
	...

   or, perhaps have a directive that says "do not place the
   menu item now, I will specify a place for it later"

3. Stick all of the arch-specific kernel hacking options under
   an arch-specific submenu, despite if they would fit better
   in the "Memory Debugging" or compiler menu.

