Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2D0VPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:15:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37902 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab2D0VPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:15:01 -0400
Date: Fri, 27 Apr 2012 17:09:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-linus-3.4-rc4-tag
Message-ID: <20120427210922.GA4177@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull this git tag

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.4-rc4-tag

which has some really good bug-fixes. Some of these had been in existence
since the 2.6.27 days, some since 3.0 - and some due to new features
added in v3.4.

The one that is most interesting is David's one - in the low-level assembler
code we had be checking events needlessly. With his patch now we do it
when the appropriate flag is set - with the added benefit that we can process
events faster. Stefano's is fixing a mistake where the Linux IRQ numbers
were ACK-ed instead of the Xen IRQ, resulting in missing interrupts. The
other ones are bootup related that can show up on various hardware.

Please pull!

David Vrabel (1):
      xen: correctly check for pending events when restoring irq flags

Konrad Rzeszutek Wilk (3):
      xen/enlighten: Disable MWAIT_LEAF so that acpi-pad won't be loaded.
      xen/smp: Fix crash when booting with ACPI hotplug CPUs.
      xen/acpi: Workaround broken BIOSes exporting non-existing C-states.

Stefano Stabellini (1):
      xen: use the pirq number to check the pirq_eoi_map

 arch/x86/xen/enlighten.c         |    4 ++--
 arch/x86/xen/smp.c               |   15 +++++++++++++++
 arch/x86/xen/xen-asm.S           |    2 +-
 drivers/xen/events.c             |    2 +-
 drivers/xen/xen-acpi-processor.c |    5 ++++-
 5 files changed, 23 insertions(+), 5 deletions(-)
