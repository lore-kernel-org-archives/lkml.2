Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1GHGAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 02:00:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33756 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1GHGAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 02:00:16 -0400
From: Tommy Lin <tommy.lin.1101@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Anton Vorontsov <avorontsov@mvista.com>
Cc: linux-kernel@vger.kernel.org, Tommy Lin <tommy.lin@caviumnetworks.com>
Subject: [PATCH 2/2] arch: arm: CNS3xxx select the correct CPU type CPU_V6K
Date: Fri,  8 Jul 2011 14:00:06 +0800
Message-Id: <1310104806-12984-1-git-send-email-tommy.lin@caviumnetworks.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM11        -> CPU_V6
ARM11 MPCore -> CPU_V6K
CNS3xxx has ARM11 MPCore CPUs (dual core), but initially select the same single
core CPU type. To select MPCore watchdog support, this patch correts the CPU
type from CPU_V6 to CPU_V6K.

Signed-off-by: Tommy Lin <tommy.lin@caviumnetworks.com>
---
 arch/arm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c148326..89eaab7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -321,7 +321,7 @@ config ARCH_CLPS711X
 
 config ARCH_CNS3XXX
 	bool "Cavium Networks CNS3XXX family"
-	select CPU_V6
+	select CPU_V6K
 	select GENERIC_CLOCKEVENTS
 	select ARM_GIC
 	select MIGHT_HAVE_PCI
-- 
1.7.6

