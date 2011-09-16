Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab1IPJWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:22:49 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47394 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1IPJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:22:48 -0400
X-Auth-Info: MBh6n4u7VjpI89QM16oyYPcbXSzrvCH8oXvCD/QD4RI=
Message-ID: <4E731565.5050307@grandegger.com>
Date: Fri, 16 Sep 2011 11:22:45 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: x86@kernel.org
CC: SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Willy Lambert <lambert.willy@gmail.com>
Subject: [PATCH] x86_64: permit to configure ISA support also for x86_64 systems
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 64-bit systems out there, like the ATOM N450, which
have ISA slots. This patch is necessary to get the "sja1000_isa"
Socket-CAN driver working on such systems.

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
---
 arch/x86/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..08ee2d4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1947,7 +1947,6 @@ source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
 
-# x86_64 have no ISA slots, but can have ISA-style DMA.
 config ISA_DMA_API
 	bool "ISA-style DMA support" if (X86_64 && EXPERT)
 	default y
@@ -1955,8 +1954,6 @@ config ISA_DMA_API
 	  Enables ISA-style DMA support for devices requiring such controllers.
 	  If unsure, say Y.
 
-if X86_32
-
 config ISA
 	bool "ISA support"
 	---help---
@@ -1966,6 +1963,8 @@ config ISA
 	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
 	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
 
+if X86_32
+
 config EISA
 	bool "EISA support"
 	depends on ISA
-- 
1.7.4.1

