Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2EUJVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:21:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38557 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab2EUJVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:21:41 -0400
Date: Mon, 21 May 2012 02:21:11 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-a6527b92e40f48b29c31be911c3d62eec484cf70@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        schwidefsky@de.ibm.com, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163106.595607369@glx-um.de>
References: <20120518163106.595607369@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] s390: Use generic time config
Git-Commit-ID: a6527b92e40f48b29c31be911c3d62eec484cf70
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:21:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6527b92e40f48b29c31be911c3d62eec484cf70
Gitweb:     http://git.kernel.org/tip/a6527b92e40f48b29c31be911c3d62eec484cf70
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:52 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:43 +0200

s390: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Link: http://lkml.kernel.org/r/20120518163106.595607369@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/Kconfig |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9015060..f9edb93 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -28,12 +28,6 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME_VSYSCALL
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y if BUG
 
@@ -122,6 +116,9 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select GENERIC_TIME_VSYSCALL
+	select GENERIC_CLOCKEVENTS
+	select KTIME_SCALAR if 32BIT
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
@@ -146,9 +143,6 @@ config 64BIT
 config 32BIT
 	def_bool y if !64BIT
 
-config KTIME_SCALAR
-	def_bool 32BIT
-
 config SMP
 	def_bool y
 	prompt "Symmetric multi-processing support"
