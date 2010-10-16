Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab0JPBR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:17:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab0JPBRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:17:17 -0400
Date: Fri, 15 Oct 2010 21:17:16 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, takata@linux-m32r.org,
        linux-m32r@ml.linux-m32r.org, viro@zeniv.linux.org.uk
Subject: [PATCH 4/4] m32r: test __LITTLE_ENDIAN__ instead of __LITTLE_ENDIAN
Message-ID: <20101016011716.GV8332@bombadil.infradead.org>
References: <20101016010952.GQ8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016010952.GQ8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes build for me... these are what's tested in byteorder.h...

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/m32r/include/asm/elf.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m32r/include/asm/elf.h b/arch/m32r/include/asm/elf.h
index 2f85412..b8da7d0 100644
--- a/arch/m32r/include/asm/elf.h
+++ b/arch/m32r/include/asm/elf.h
@@ -82,9 +82,9 @@ typedef elf_fpreg_t elf_fpregset_t;
  * These are used to set parameters in the core dumps.
  */
 #define ELF_CLASS	ELFCLASS32
-#if defined(__LITTLE_ENDIAN)
+#if defined(__LITTLE_ENDIAN__)
 #define ELF_DATA	ELFDATA2LSB
-#elif defined(__BIG_ENDIAN)
+#elif defined(__BIG_ENDIAN__)
 #define ELF_DATA	ELFDATA2MSB
 #else
 #error no endian defined
-- 
1.7.3.1

