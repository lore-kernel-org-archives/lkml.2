Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0KPWmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:42:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38110 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0KPWmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:42:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mZFArZaAecD/EZhr2T3VN99X2PYsxHys+/ckmUsq3fLr2eY9AI7C2ZBb2K+rxmP9kd
         18iOQmBTZB0tU5vZ+/v3rbH41XPBhH4H0e/qpiW+/3kRo2vsreCyyTXXX5x2HQRsaR5J
         pvnCBw0hddOXRHVuje5fsDxg09VnMmOwClg/g=
From: dirk.brandewie@gmail.com
To: devicetree-discuss@lists.ozlabs.org
Cc: sodaville@linutronix.de, arjan@linux.intel.com, dirk.brandewie@gmail.com,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Add the ability to link device blobs into vmlinux
Date: Tue, 16 Nov 2010 14:41:35 -0800
Message-Id: <cover.1289943240.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch set adds the ability to link device tree blob(s)
directly into the vmlinux image and specify the blob to be used via a
kernel command line option.

Patch 1 implements the changes to include/asm-generic/vmlinux.lds.h,
add generic rules for building and linking the DTB's into vmlinux.

Patch 2 adds the command line option, the functions for the
platform code to retrieve the value passed in and locate the matching
blob in the image.  This patch has been tested on x86.

Patch 3-5 show using the generic dts->dtb rule in x86, microblaze and
powerpc. The microblaze and powerpc patches have only been compile
tested.

Dirk Brandewie (5):
  of: Add support for linking device tree blobs into vmlinux
  of/fdt: add kernel command line option for dtb_compat string
  x86/of:  Add building device tree blob(s) into image.
  of/powerpc: Move build to use generic dts->dtb rule
  of/microblaze: Move build to use generic dts->dtb rule

 Documentation/kernel-parameters.txt |    7 +++++
 arch/microblaze/boot/Makefile       |   13 +--------
 arch/powerpc/boot/Makefile          |    7 -----
 arch/x86/Kconfig                    |    6 +++-
 arch/x86/kernel/Makefile            |    6 ++++
 arch/x86/kernel/dts/Kconfig         |    7 +++++
 drivers/of/fdt.c                    |   52 +++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h   |   19 +++++++++++-
 include/linux/of_fdt.h              |    4 +++
 scripts/Makefile.lib                |   20 +++++++++++++
 10 files changed, 119 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/kernel/dts/Kconfig

-- 
1.7.2.3

