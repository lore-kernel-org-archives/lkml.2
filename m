Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab0KQD1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:27:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980Ab0KQD1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:27:35 -0500
Date: Tue, 16 Nov 2010 22:27:22 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>
Subject: failure to boot any kernel since 2.6.36rc6-git2.
Message-ID: <20101117032721.GA8630@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every kernel between 2.6.36-rc6 and 2.6.37rc2 fails to boot on my laptop.
The -git's that followed -rc6 had a fairly large (considering rc6) acpi merge,
which I suspected was the cause.

The boot failure manifests by a complete lockup as soon as usb initializes.

I spent the last 6 hours bisecting it, and every bisect point failed to boot
(sometimes in slightly different ways, but always just after usb initializes)
http://codemonkey.org.uk/junk/usb-hang/IMG_0054.JPG and 
http://codemonkey.org.uk/junk/usb-hang/IMG_0056.JPG being the more common type,
but http://codemonkey.org.uk/junk/usb-hang/IMG_0055.JPG showed up at one bisect point.

The real kicker is that it eventually pointed at something that can't be relevant,
as it patches a file that I don't even compile in my config.

git bisect start
# bad: [c6ea21e35bf3691cad59647c771e6606067f627d] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
git bisect bad c6ea21e35bf3691cad59647c771e6606067f627d
# good: [899611ee7d373e5eeda08e9a8632684e1ebbbf00] Linux 2.6.36-rc6
git bisect good 899611ee7d373e5eeda08e9a8632684e1ebbbf00
# bad: [35ec42167bb5f13db93f1e8c13298eb564f95142] Merge branch 'idle-release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6
git bisect bad 35ec42167bb5f13db93f1e8c13298eb564f95142
# bad: [64aab720bdf8771214a7c88872bd8e3194c2d279] i7core_edac: fix panic in udimm sysfs attributes registration
git bisect bad 64aab720bdf8771214a7c88872bd8e3194c2d279
# bad: [77f890223338c890fc33972673d2bd3a53061570] Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx
git bisect bad 77f890223338c890fc33972673d2bd3a53061570
# bad: [9d457c60ba783c709c750b851d07f0ac8af78ce9] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6
git bisect bad 9d457c60ba783c709c750b851d07f0ac8af78ce9
# bad: [90182317a9e383474613aa60e9d61d57bdf17c3e] mfd: Fix max8925 irq control bit incorrect setting
git bisect bad 90182317a9e383474613aa60e9d61d57bdf17c3e
# bad: [c9d66d3515bbb0ad8062721487de7ade02d2b936] mfd: Ignore non-GPIO IRQs when setting wm831x IRQ types
git bisect bad c9d66d3515bbb0ad8062721487de7ade02d2b936


Before I start going through every one of those acpi commits one by one, does
anything jump out from the screen captures that fingers a specific patch ?


Sidenote: booting with initcall_debug didn't print anything. Did that break ?

	Dave
