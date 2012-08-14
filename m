Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2HNXWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:22:06 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35438 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab2HNXWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:22:03 -0400
Message-ID: <1344986638.4430.22.camel@footlong>
Subject: [PATCH V3 0/3] tpm: Add new vTPM device driver for PPC64
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, key@linux.vnet.ibm.com, adlai@us.ibm.com,
        adlai@linux.vnet.ibm.com
Date: Tue, 14 Aug 2012 18:23:58 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081423-7182-0000-0000-00000248EF64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log V3:
- Replaced TPM_NO_EVENT_LOG macro with stubs
- Removed tpm_noeventlog.c file 
- Called of_node_put() before return in tpm_of.c

Change log V2:
- Removed unnecessary tpm_bios_log_setup and tpm_bios_log_teardown
  functions in tpm_eventlog.h (patch 3/3).
- Added more descriptions on vTPM (patch 1/3).

These patches add support for IBM vTPM for PPC64. This new device driver
works on firmware that supports vTPM (firmware release 740 or higher).

Tested on Power7+ system with firmware level ZM770_001.

Applied to Kent Yoder tree at:
https://github.com/shpedoikal/linux/tree/v3.6-rc1-tpmdd-staging

Ashley Lai (3):
  drivers/char/tpm: Add new device driver to support IBM vTPM
  PPC64: Add support for instantiating SML from Open Firmware
  drivers/char/tpm: Add securityfs support for event log

 arch/powerpc/kernel/prom_init.c |   62 ++++
 drivers/char/tpm/Kconfig        |    8 +
 drivers/char/tpm/Makefile       |    6 +
 drivers/char/tpm/tpm.h          |   13 +-
 drivers/char/tpm/tpm_eventlog.h |   15 +
 drivers/char/tpm/tpm_ibmvtpm.c  |  749 +++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_ibmvtpm.h  |   83 +++++
 drivers/char/tpm/tpm_of.c       |   73 ++++
 8 files changed, 997 insertions(+), 12 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.c
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.h
 create mode 100644 drivers/char/tpm/tpm_of.c


