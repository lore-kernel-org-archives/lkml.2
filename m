Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0IWPkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:40:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab0IWPku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:40:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Fix endianess of ext2 bitops
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>, David Howells <dhowells@redhat.com>
Date: Thu, 23 Sep 2010 16:40:22 +0100
Message-ID: <20100923154022.15133.20046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

The MN10300 arch ext2 bitops assume a big-endian kernel, but the MN10300 arch
only runs in little-endian mode.

Reported-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/bitops.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
index 942093b..6208ea6 100644
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -229,9 +229,9 @@ int ffs(int x)
 #include <asm-generic/bitops/hweight.h>
 
 #define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_bit((nr) ^ 0x18, (addr))
+	test_and_set_bit((nr), (addr))
 #define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_bit((nr) ^ 0x18, (addr))
+	test_and_clear_bit((nr), (addr))
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix-le.h>

