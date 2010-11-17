Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813Ab0KQMnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:43:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:36159 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934510Ab0KQMnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:43:09 -0500
Date: Wed, 17 Nov 2010 12:42:43 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk, randy.dunlap@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20101115101406.77e072ef.randy.dunlap@oracle.com>
References: <20101115101406.77e072ef.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, mrst: Fix dependencies of "select INTEL_SCU_IPC"
Message-ID: <tip-ad02519a0d27da4a0a50cbc696e810c94e27c28e@git.kernel.org>
Git-Commit-ID: ad02519a0d27da4a0a50cbc696e810c94e27c28e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Nov 2010 12:42:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad02519a0d27da4a0a50cbc696e810c94e27c28e
Gitweb:     http://git.kernel.org/tip/ad02519a0d27da4a0a50cbc696e810c94e27c28e
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Mon, 15 Nov 2010 10:14:06 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 17 Nov 2010 13:41:44 +0100

x86, mrst: Fix dependencies of "select INTEL_SCU_IPC"

commit b9fc71f47 (x86, mrst: The shutdown for MRST requires the SCU
IPC mechanism) introduced the following warning:

 warning: (X86_MRST && PCI && PCI_GOANY && X86_32 &&
 X86_EXTENDED_PLATFORM && X86_IO_APIC) selects INTEL_SCU_IPC which has
 unmet direct dependencies (X86 && X86_PLATFORM_DEVICES && X86_MRST)

which is due to the hierarchical menu structure.

Select X86_PLATFORM_DEVICES as well.

Originally-from: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20101115101406.77e072ef.randy.dunlap@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6e877b9..655fcf5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -400,6 +400,7 @@ config X86_MRST
 	select I2C
 	select SPI
 	select INTEL_SCU_IPC
+	select X86_PLATFORM_DEVICES
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
