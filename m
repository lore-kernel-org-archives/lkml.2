Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2CUV2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:28:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56197 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab2CUV21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:28:27 -0400
Message-ID: <1332365297.3858.5.camel@key-ThinkPad-W510>
Subject: [PATCH 00/17] Platform Facilities Option and crypto accelerator
 driver
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 21 Mar 2012 16:28:17 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032121-2398-0000-0000-00000538A8E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for a new device type, the Platform
Facilities Option (PFO).  PFO resources are a set of accelerators that
share some system resources managed by the VIO bus.  This patchset
includes the basic support for the devices in the VIO bus code along
with drivers for the random number generator and the cryptographic
accelerators.

Please cc me on replies.

Thanks,
Kent

Kent Yoder (12):
  powerpc: crypto: AES-CBC mode routines for nx encryption
  powerpc: crypto: AES-CCM mode routines for nx encryption
  powerpc: crypto: AES-CTR mode routines for nx encryption
  powerpc: crypto: AES-ECB mode routines for nx encryption
  powerpc: crypto: AES-GCM mode routines for nx encryption
  powerpc: crypto: AES-XCBC mode routines for nx encryption
  powerpc: crypto: SHA256 hash routines for nx encryption
  powerpc: crypto: SHA512 hash routines for nx encryption
  powerpc: crypto: nx driver code supporting nx encryption
  powerpc: crypto: sysfs routines and docs for the nx device driver
  powerpc: crypto: Build files for the nx device driver
  powerpc: crypto: enable the PFO-based encryption device

Michael Neuling (1):
  hwrng: pseries - PFO-based hwrng driver

Robert Jennings (4):
  powerpc: Add new hvcall constants to support PFO
  powerpc: Add pseries update notifier for OFDT prop changes
  powerpc: Add PFO support to the VIO bus
  pseries: Enabled the PFO-based RNG accelerator

 Documentation/powerpc/pfo-nx-crypto.txt     |   52 ++
 arch/powerpc/Makefile                       |    1 +
 arch/powerpc/crypto/nx/Makefile             |   11 +
 arch/powerpc/crypto/nx/nx-aes-cbc.c         |  135 +++++
 arch/powerpc/crypto/nx/nx-aes-ccm.c         |  466 ++++++++++++++++++
 arch/powerpc/crypto/nx/nx-aes-ctr.c         |  175 +++++++
 arch/powerpc/crypto/nx/nx-aes-ecb.c         |  133 +++++
 arch/powerpc/crypto/nx/nx-aes-gcm.c         |  352 +++++++++++++
 arch/powerpc/crypto/nx/nx-aes-xcbc.c        |  230 +++++++++
 arch/powerpc/crypto/nx/nx-sha256.c          |  240 +++++++++
 arch/powerpc/crypto/nx/nx-sha512.c          |  259 ++++++++++
 arch/powerpc/crypto/nx/nx.c                 |  710 +++++++++++++++++++++++++++
 arch/powerpc/crypto/nx/nx.h                 |  190 +++++++
 arch/powerpc/crypto/nx/nx_csbcpb.h          |  246 +++++++++
 arch/powerpc/crypto/nx/nx_sysfs.c           |  194 ++++++++
 arch/powerpc/include/asm/hvcall.h           |   25 +-
 arch/powerpc/include/asm/pSeries_reconfig.h |   12 +
 arch/powerpc/include/asm/vio.h              |   46 ++
 arch/powerpc/kernel/prom_init.c             |   19 +-
 arch/powerpc/kernel/vio.c                   |  274 +++++++++--
 arch/powerpc/platforms/pseries/reconfig.c   |    7 +
 drivers/char/hw_random/Kconfig              |   13 +
 drivers/char/hw_random/Makefile             |    1 +
 drivers/char/hw_random/pseries-rng.c        |   99 ++++
 drivers/crypto/Kconfig                      |   18 +
 25 files changed, 3865 insertions(+), 43 deletions(-)
 create mode 100644 Documentation/powerpc/pfo-nx-crypto.txt
 create mode 100644 arch/powerpc/crypto/nx/Makefile
 create mode 100644 arch/powerpc/crypto/nx/nx-aes-cbc.c
 create mode 100644 arch/powerpc/crypto/nx/nx-aes-ccm.c
 create mode 100644 arch/powerpc/crypto/nx/nx-aes-ctr.c
 create mode 100644 arch/powerpc/crypto/nx/nx-aes-ecb.c
 create mode 100644 arch/powerpc/crypto/nx/nx-aes-gcm.c
 create mode 100644 arch/powerpc/crypto/nx/nx-aes-xcbc.c
 create mode 100644 arch/powerpc/crypto/nx/nx-sha256.c
 create mode 100644 arch/powerpc/crypto/nx/nx-sha512.c
 create mode 100644 arch/powerpc/crypto/nx/nx.c
 create mode 100644 arch/powerpc/crypto/nx/nx.h
 create mode 100644 arch/powerpc/crypto/nx/nx_csbcpb.h
 create mode 100644 arch/powerpc/crypto/nx/nx_sysfs.c
 create mode 100644 drivers/char/hw_random/pseries-rng.c


