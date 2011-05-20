Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842Ab1ETAP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:15:56 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35546 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934850Ab1ETAL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:56 -0400
X-Sasl-enc: d29SzfPgA059UwSEkji/N89iNVNePx3+4+BzGWCMlEOv 1305850315
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/44] x86: Better comments for get_bios_ebda()
Date: Thu, 19 May 2011 17:10:47 -0700
Message-Id: <1305850262-9575-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Make the comments a bit clearer for get_bios_ebda so that it actually
tells us what it is returning.

Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/bios_ebda.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/bios_ebda.h b/arch/x86/include/asm/bios_ebda.h
index 5174cf0..aa6a317 100644
--- a/arch/x86/include/asm/bios_ebda.h
+++ b/arch/x86/include/asm/bios_ebda.h
@@ -4,11 +4,14 @@
 #include <asm/io.h>
 
 /*
- * there is a real-mode segmented pointer pointing to the
- * 4K EBDA area at 0x40E.
+ * Returns physical address of EBDA.  Returns 0 if there is no EBDA.
  */
 static inline unsigned int get_bios_ebda(void)
 {
+	/*
+	 * There is a real-mode segmented pointer pointing to the
+	 * 4K EBDA area at 0x40E.
+	 */
 	unsigned int address = *(unsigned short *)phys_to_virt(0x40E);
 	address <<= 4;
 	return address;	/* 0 means none */
-- 
1.7.4.2

