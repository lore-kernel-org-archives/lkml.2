Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1A2A1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:27:09 -0500
Received: from claw.goop.org ([74.207.240.146]:40212 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab1A2A1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:27:06 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 0/2] x86/microcode: support for microcode update in Xen dom0
Date: Fri, 28 Jan 2011 16:26:52 -0800
Message-Id: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hi all,

I'm proposing this for 2.6.39.

This series adds a new "Xen" microcode update type, in addition to
Intel and AMD.

The Xen hypervisor is responsible for performing the actual microcode
update (since only it knows what physical CPUs are in the system and
has sufficient privilege to access them), but it requires the dom0
kernel to provide the actual microcode update data.

Xen update mechanism is uniform independent of the CPU type, but the
driver must know where to find the data file, which depends on the CPU
type.  And since the update hypercall updates all CPUs, we only need
to execute it once on any CPU - but for simplicity it just runs it only
on (V)CPU 0.

Thanks,
	J

Jeremy Fitzhardinge (1):
  xen: add CPU microcode update driver

Stephen Tweedie (1):
  xen dom0: Add support for the platform_ops hypercall

 arch/x86/include/asm/microcode.h     |    9 ++
 arch/x86/include/asm/xen/hypercall.h |    8 ++
 arch/x86/kernel/Makefile             |    1 +
 arch/x86/kernel/microcode_core.c     |    5 +-
 arch/x86/kernel/microcode_xen.c      |  198 ++++++++++++++++++++++++++++++
 arch/x86/xen/Kconfig                 |    4 +
 include/xen/interface/platform.h     |  222 ++++++++++++++++++++++++++++++++++
 include/xen/interface/xen.h          |    2 +
 8 files changed, 448 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/microcode_xen.c
 create mode 100644 include/xen/interface/platform.h

-- 
1.7.3.5

