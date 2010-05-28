Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0E1Lxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:53:30 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:34607 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab0E1Lx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:53:28 -0400
Date: Fri, 28 May 2010 13:54:28 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH] lib: add s390 to atomic64_dec_if_positive archs
Message-ID: <20100528115428.GD3686@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Add s390 to list of architectures that have atomic64_dec_if_positive
implemented so we get rid of this warning:

lib/atomic64_test.c:129:2: warning: #warning Please implement
atomic64_dec_if_positive for your architecture, and add it to the IF above

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Luca Barbieri <luca@luca-barbieri.com>
---
 lib/atomic64_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -112,7 +112,8 @@ static __init int test_atomic64(void)
 	r += one;
 	BUG_ON(v.counter != r);
 
-#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(_ASM_GENERIC_ATOMIC64_H)
+#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || \
+    defined(CONFIG_S390) || defined(_ASM_GENERIC_ATOMIC64_H)
 	INIT(onestwos);
 	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
 	r -= one;
