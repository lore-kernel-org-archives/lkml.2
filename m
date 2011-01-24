Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1AXR4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:56:20 -0500
Received: from service87.mimecast.com ([94.185.240.25]:50838 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753843Ab1AXR4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:56:17 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 01/19] ARM: Make the argument to virt_to_phys() "const volatile"
Date: Mon, 24 Jan 2011 17:55:43 +0000
Message-Id: <1295891761-18366-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c.dirty
In-Reply-To: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 Jan 2011 17:56:10.0303 (UTC) FILETIME=[FB9B54F0:01CBBBEF]
X-MC-Unique: 111012417561406901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0OI0fNu031641

Changing the virt_to_phys() argument to "const volatile void *" avoids
compiler warnings in some situations where this function is used.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/memory.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 23c2e8e..d0ee74b 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -188,7 +188,7 @@
  * translation for translating DMA addresses.  Use the driver
  * DMA support - see dma-mapping.h.
  */
-static inline unsigned long virt_to_phys(void *x)
+static inline unsigned long virt_to_phys(const volatile void *x)
 {
 	return __virt_to_phys((unsigned long)(x));
 }

