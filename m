Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1BWCWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:22:08 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47790 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab1BWCWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:22:07 -0500
Subject: [PATCH v4 0/7] Basic ARM devicetree support
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Date: Tue, 22 Feb 2011 19:22:03 -0700
Message-ID: <20110223021524.18318.71902.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fourth posting.  v4 rebases on top of Nicolas' patch to merge
lookup_machine_type() into setup_machine().  It also adds
documentation and error output when the kernel cannot find a
machine_desc that matches the top level compatible property.

I'm not asking for these patches to be merged into mainline yet, but
I'm fairly confident that they should be pretty close to their final
form.

Not included in this series is:
- Russell's patch to remove early vetting of the machine type number
- Rob's patch to map the region if atags or the dtb are not within the
  first 1MB of ram.
- Nicolas' patch to eliminate lookup_machine_type()
However, I am carrying those patches in my devicetree/arm and
devicetree/test branches for anyone who wants to try them out.

Please test.

...

This patch series allows CONFIG_OF to be enabled on ARM and allows the
kernel to accept a dtb pointer from boot firmware instead of atags.
If a dtb is passed, then the kernel will use the root 'compatible'
property to find a matching machine_desc, and it will use it to obtain
the memory layout, initrd location and kernel parameters string.

Only limited device tree support is enabled here.  It does not perform
any kind of device registration from device tree data.  That support
will be enabled in a later patch set.  Rather, this series is a stable
base that other engineers can use to start working on device tree
support for their platforms.

Tested on Versatile (qemu) and nVidia Tegra Harmony.  Kernel compiles
and boots with CONFIG_OF both on and off, both with and without passing
a device tree blob.

This series is reflected in the following branch (stable; will not be
rebased):

 git://git.secretlab.ca/git/linux-2.6 devicetree/arm

The 'clean' patches (rebased) can be found here:

 git://git.secretlab.ca/git/linux-2.6 devicetree/test

---

Grant Likely (6):
      arm/dt: Make __vet_atags also accept a dtb image
      arm/dt: consolidate atags setup into setup_machine_atags
      arm/dt: probe for platforms via the device tree
      arm/dt: Basic versatile devicetree support
      arm/dt: Basic tegra devicetree support
      dt: add documentation of ARM dt boot interface

Jeremy Kerr (1):
      arm/dt: Allow CONFIG_OF on ARM


 Documentation/arm/Booting                       |   33 +++++
 Documentation/devicetree/booting-without-of.txt |   40 ++++++
 arch/arm/Kconfig                                |    7 +
 arch/arm/include/asm/mach/arch.h                |    9 +
 arch/arm/include/asm/prom.h                     |   37 ++++++
 arch/arm/include/asm/setup.h                    |    5 +
 arch/arm/kernel/Makefile                        |    1 
 arch/arm/kernel/devtree.c                       |  147 +++++++++++++++++++++++
 arch/arm/kernel/head-common.S                   |   24 +++-
 arch/arm/kernel/head.S                          |    8 +
 arch/arm/kernel/setup.c                         |   86 ++++++++-----
 arch/arm/mach-tegra/board-harmony.c             |    6 +
 arch/arm/mach-versatile/versatile_ab.c          |    6 +
 arch/arm/mach-versatile/versatile_pb.c          |    6 +
 arch/arm/mm/init.c                              |   11 ++
 15 files changed, 379 insertions(+), 47 deletions(-)
 create mode 100644 arch/arm/include/asm/prom.h
 create mode 100644 arch/arm/kernel/devtree.c

-- 
Signature
