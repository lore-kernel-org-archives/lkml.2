Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2HGTmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:42:06 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39642 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab2HGTmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:42:01 -0400
Message-ID: <1344367748.24990.1.camel@footlong>
Subject: [PATCH 0/3] tpm: Add new vTPM device driver for PPC64
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, key@linux.vnet.ibm.com, adlai@us.ibm.com,
        adlai@linux.vnet.ibm.com
Date: Tue, 07 Aug 2012 14:29:08 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080719-7182-0000-0000-00000234EDE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for IBM vTPM for PPC64.  This new device driver
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
 drivers/char/tpm/tpm_eventlog.h   |   24 ++
 drivers/char/tpm/tpm_ibmvtpm.c    |  750 +++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_ibmvtpm.h    |   83 ++++
 drivers/char/tpm/tpm_noeventlog.c |   21 +
 drivers/char/tpm/tpm_of.c         |   68 ++++
 10 files changed, 1034 insertions(+), 13 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.c
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.h
 create mode 100644 drivers/char/tpm/tpm_noeventlog.c
 create mode 100644 drivers/char/tpm/tpm_of.c


