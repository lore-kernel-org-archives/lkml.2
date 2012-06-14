Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab2FNUcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:32:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38363 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab2FNUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:32:18 -0400
Date: Thu, 14 Jun 2012 16:24:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.5-rc2-tag
Message-ID: <20120614202449.GA24693@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull my tag:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.5-rc2-tag

which has accumulated some good bug-fixes. The tag itself has the description - which
I am copying here:

Five bug-fixes:
 - When booting as PVHVM we would try to use PV console - but would not validate
   the parameters causing us to crash during restore b/c we re-use the wrong event
   channel.
 - When booting on machines with SR-IOV PCI bridge we didn't check for the bridge
   and tried to use it.
 - Under AMD machines would advertise the APERFMPERF resulting in needless amount
   of MSRs from the guest.
 - A global value (xen_released_pages) was not subtracted at bootup when pages
   were added back in. This resulted in the balloon worker having the wrong
   account of how many pages were truly released.
 - Fix dead-lock when xen-blkfront is run in the same domain as xen-blkback.


Please pull!

Andre Przywara (1):
      xen/setup: filter APERFMPERF cpuid feature out

Konrad Rzeszutek Wilk (5):
      xen/hvc: Collapse error logic.
      xen/hvc: Fix error cases around HVM_PARAM_CONSOLE_PFN
      xen/hvc: Check HVM_PARAM_CONSOLE_[EVTCHN|PFN] for correctness.
      xen/events: Add WARN_ON when quick lookup found invalid type.
      xen/balloon: Subtract from xen_released_pages the count that is populated.

Stefano Stabellini (1):
      xen: mark local pages as FOREIGN in the m2p_override

Zhang, Yang Z (1):
      xen/pci: Check for PCI bridge before using it.

 arch/x86/xen/enlighten.c  |    8 ++++++++
 arch/x86/xen/p2m.c        |   36 ++++++++++++++++++++++++++++++++++++
 arch/x86/xen/setup.c      |    3 ++-
 drivers/tty/hvc/hvc_xen.c |   31 +++++++++++++++++--------------
 drivers/xen/events.c      |    9 +++++++++
 drivers/xen/pci.c         |    2 +-
 6 files changed, 73 insertions(+), 16 deletions(-)
