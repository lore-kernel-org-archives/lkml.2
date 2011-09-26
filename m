Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1IZS1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:27:42 -0400
Received: from claw.goop.org ([74.207.240.146]:32976 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab1IZS1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:27:30 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <xen-devel@lists.xensource.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 0/3] xen: enable settime in Xen dom0
Date: Mon, 26 Sep 2011 11:27:22 -0700
Message-Id: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Proposed patch for the v3.2 merge window, but it should be probably be
put into v3.0 and v3.1 stable branches too (but not important enough
to burn any of my "Linus, merge this in late -rc karma").

This series implements the time-setting pvops for Xen dom0 so that a
privileged kernel can set the system time via Xen.  This had
previously been a no-op, because upstream Linux only supported
non-privieged operation, and so there was no point in trying to set
the system time.

Also available at:
     git://github.com/jsgf/linux-xen.git upstream/xen-settime

Thanks,
	J

Jeremy Fitzhardinge (2):
  xen: add dom0_op hypercall
  xen/dom0: set wallclock time in Xen

Yu Ke (1):
  xen/acpi: Domain0 acpi parser related platform hypercall

 arch/ia64/include/asm/xen/interface.h |    1 +
 arch/x86/include/asm/xen/hypercall.h  |    8 +
 arch/x86/include/asm/xen/interface.h  |    1 +
 arch/x86/xen/time.c                   |   16 ++-
 include/xen/interface/platform.h      |  320 +++++++++++++++++++++++++++++++++
 include/xen/interface/xen.h           |    1 +
 6 files changed, 346 insertions(+), 1 deletions(-)
 create mode 100644 include/xen/interface/platform.h

-- 
1.7.6.2

