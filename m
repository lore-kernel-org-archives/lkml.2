Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab1JaROv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:14:51 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51998 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932854Ab1JaROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:14:50 -0400
Subject: [RFC PATCH v3 10/10] fadump: Introduce config option for firmware
	assisted dump feature
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Haren Myneni <hbabu@us.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Amerigo Wang <amwang@redhat.com>, Milton Miller <miltonm@bga.com>,
        Anton Blanchard <anton@samba.org>
Date: Mon, 31 Oct 2011 22:43:54 +0530
Message-ID: <20111031171354.12259.92108.stgit@mars.in.ibm.com>
In-Reply-To: <20111031170200.12259.27663.stgit@mars.in.ibm.com>
References: <20111031170200.12259.27663.stgit@mars.in.ibm.com>
User-Agent: StGit/0.15-1-ged5e-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11103107-1396-0000-0000-0000001DCB19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

This patch introduces a new config option CONFIG_FA_DUMP for firmware
assisted dump feature on Powerpc (ppc64) architecture.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 arch/powerpc/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6926b61..7ce773c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -379,6 +379,19 @@ config PHYP_DUMP
 
 	  If unsure, say "N"
 
+config FA_DUMP
+	bool "Firmware-assisted dump"
+	depends on PPC64 && PPC_RTAS && CRASH_DUMP
+	help
+	  A robust mechanism to get reliable kernel crash dump with
+	  assistance from firmware. This approach does not use kexec,
+	  instead firmware assists in booting the kdump kernel
+	  while preserving memory contents. Firmware-assisted dump
+	  is meant to be a kdump replacement offering robustness and
+	  speed not possible without system firmware assistance.
+
+	  If unsure, say "N"
+
 config PPCBUG_NVRAM
 	bool "Enable reading PPCBUG NVRAM during boot" if PPLUS || LOPEC
 	default y if PPC_PREP

