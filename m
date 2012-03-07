Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031717Ab2CGAa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:30:58 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33026 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031640Ab2CGAax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:30:53 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Russell King <linux@arm.linux.org.uk>, nico@fluxnic.net,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 3/3] ARM: Allow the user to enable UIMAGE_KERNEL_NOLOAD
Date: Tue,  6 Mar 2012 17:30:38 -0700
Message-Id: <1331080238-1524-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When AUTO_ZRELADDR is enabled, ARM zImages are relocatable, and hence
the user may use mkimage's -T kernel_noload option if their bootloader
supports it.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4040796..5459b2e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2055,6 +2055,7 @@ config CRASH_DUMP
 
 config AUTO_ZRELADDR
 	bool "Auto calculation of the decompressed kernel image address"
+	select ALLOW_UIMAGE_KERNEL_NOLOAD
 	depends on !ZBOOT_ROM && !ARCH_U300
 	help
 	  ZRELADDR is the physical address where the decompressed kernel
-- 
1.7.0.4

