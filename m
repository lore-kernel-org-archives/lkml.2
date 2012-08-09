Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949Ab2HIXAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 19:00:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38372 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892Ab2HIXAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:00:07 -0400
Message-ID: <1344553253.28791.7.camel@footlong>
Subject: [PATCH V2 0/3] tpm: Add new vTPM device driver for PPC64
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, key@linux.vnet.ibm.com, adlai@us.ibm.com,
        adlai@linux.vnet.ibm.com
Date: Thu, 09 Aug 2012 18:00:53 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080923-7282-0000-0000-00000BD34B38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log V2:
- Removed unnecessary tpm_bios_log_setup and tpm_bios_log_teardown
  functions in tpm_eventlog.h (patch 3/3).
- Added more descriptions on vTPM (patch 1/3).

These patches add support for IBM vTPM for PPC64. This new device driver
works on firmware that supports vTPM (firmware release 740 or higher).

Tested on Power7+ system with firmware level ZM770_001.

Applied to Kent Yoder patch to modularize event log located at:
https://github.com/shpedoikal/linux/tree/tpmdd-next

Ashley Lai (3):
  drivers/char/tpm: Add new device driver to support IBM vTPM
  PPC64: Add support for instantiating SML from Open Firmware
  drivers/char/tpm: Add securityfs support for event log

 arch/powerpc/kernel/prom_init.c   |   64 ++++
 drivers/char/tpm/Kconfig          |    8 +
 drivers/char/tpm/Makefile         |    9 +-
 drivers/char/tpm/tpm.h            |   13 +-
 drivers/char/tpm/tpm_eventlog.c   |    7 +
 drivers/char/tpm/tpm_eventlog.h   |   14 +
 drivers/char/tpm/tpm_ibmvtpm.c    |  750 +++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_ibmvtpm.h    |   83 ++++
 drivers/char/tpm/tpm_noeventlog.c |   21 +
 drivers/char/tpm/tpm_of.c         |   68 ++++
 10 files changed, 1024 insertions(+), 13 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.c
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.h
 create mode 100644 drivers/char/tpm/tpm_noeventlog.c
 create mode 100644 drivers/char/tpm/tpm_of.c


