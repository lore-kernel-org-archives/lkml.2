Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab2FMD6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:58:13 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:42324 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2FMD6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:58:11 -0400
Date: Wed, 13 Jun 2012 13:04:38 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: bhutchings@solarflare.com, grundler@parisc-linux.org, arnd@arndb.de,
        benh@kernel.crashing.org, avi@redhat.com, mtosatti@redhat.com,
        linux-net-drivers@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: [PATCH 4/5] powerpc: bitops: Introduce {clear,set}_bit_le()
Message-Id: <20120613130438.b1cd04db.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120613130054.b5695621.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120613130054.b5695621.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

Needed to replace test_and_set_bit_le() in virt/kvm/kvm_main.c which is
being used for this missing function.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/bitops.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index efdc926..dc2cf9c 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -288,6 +288,16 @@ static __inline__ int test_bit_le(unsigned long nr,
 	return (tmp[nr >> 3] >> (nr & 7)) & 1;
 }
 
+static inline void set_bit_le(int nr, void *addr)
+{
+	set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline void clear_bit_le(int nr, void *addr)
+{
+	clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
 static inline void __set_bit_le(int nr, void *addr)
 {
 	__set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
-- 
1.7.5.4

