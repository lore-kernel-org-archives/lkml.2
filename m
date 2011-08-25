Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1HYTLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:11:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37899 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab1HYTLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:11:47 -0400
Date: Thu, 25 Aug 2011 22:11:43 +0300
From: "Maxin B. John" <maxin.john@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH]arm: nwfpe: '&pointer[0]' to 'pointer' fix
Message-ID: <20110825191143.GA3149@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'&pointer[0]' to 'pointer' fix in arch/arm/nwfpe/fpa11_cpdt.c 

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/arch/arm/nwfpe/fpa11_cpdt.c b/arch/arm/nwfpe/fpa11_cpdt.c
index d31c49f..6e9eb45 100644
--- a/arch/arm/nwfpe/fpa11_cpdt.c
+++ b/arch/arm/nwfpe/fpa11_cpdt.c
@@ -42,11 +42,11 @@ static inline void loadDouble(const unsigned int Fn, const unsigned int __user *
 	p = (unsigned int *) &fpa11->fpreg[Fn].fDouble;
 	fpa11->fType[Fn] = typeDouble;
 #ifdef __ARMEB__
-	get_user(p[0], &pMem[0]);	/* sign & exponent */
+	get_user(p[0], pMem);	/* sign & exponent */
 	get_user(p[1], &pMem[1]);
 #else
 	get_user(p[0], &pMem[1]);
-	get_user(p[1], &pMem[0]);	/* sign & exponent */
+	get_user(p[1], pMem);	/* sign & exponent */
 #endif
 }
 
@@ -57,7 +57,7 @@ static inline void loadExtended(const unsigned int Fn, const unsigned int __user
 	unsigned int *p;
 	p = (unsigned int *) &fpa11->fpreg[Fn].fExtended;
 	fpa11->fType[Fn] = typeExtended;
-	get_user(p[0], &pMem[0]);	/* sign & exponent */
+	get_user(p[0], pMem);	/* sign & exponent */
 #ifdef __ARMEB__
 	get_user(p[1], &pMem[1]);	/* ms bits */
 	get_user(p[2], &pMem[2]);	/* ls bits */
@@ -75,7 +75,7 @@ static inline void loadMultiple(const unsigned int Fn, const unsigned int __user
 	unsigned long x;
 
 	p = (unsigned int *) &(fpa11->fpreg[Fn]);
-	get_user(x, &pMem[0]);
+	get_user(x, pMem);
 	fpa11->fType[Fn] = (x >> 14) & 0x00000003;
 
 	switch (fpa11->fType[Fn]) {
@@ -150,10 +150,10 @@ static inline void storeDouble(struct roundingData *roundData, const unsigned in
 	}
 
 #ifdef __ARMEB__
-	put_user(val.i[0], &pMem[0]);	/* msw */
+	put_user(val.i[0], pMem);	/* msw */
 	put_user(val.i[1], &pMem[1]);	/* lsw */
 #else
-	put_user(val.i[1], &pMem[0]);	/* msw */
+	put_user(val.i[1], pMem);	/* msw */
 	put_user(val.i[0], &pMem[1]);	/* lsw */
 #endif
 }
@@ -180,7 +180,7 @@ static inline void storeExtended(const unsigned int Fn, unsigned int __user *pMe
 		val.f = fpa11->fpreg[Fn].fExtended;
 	}
 
-	put_user(val.i[0], &pMem[0]);	/* sign & exp */
+	put_user(val.i[0], pMem);	/* sign & exp */
 #ifdef __ARMEB__
 	put_user(val.i[1], &pMem[1]);	/* msw */
 	put_user(val.i[2], &pMem[2]);
@@ -205,7 +205,7 @@ static inline void storeMultiple(const unsigned int Fn, unsigned int __user *pMe
 		{
 			put_user(p[0], &pMem[2]);	/* single */
 			put_user(p[1], &pMem[1]);	/* double msw */
-			put_user(nType << 14, &pMem[0]);
+			put_user(nType << 14, pMem);
 		}
 		break;
 
@@ -214,7 +214,7 @@ static inline void storeMultiple(const unsigned int Fn, unsigned int __user *pMe
 		{
 			put_user(p[2], &pMem[1]);	/* msw */
 			put_user(p[1], &pMem[2]);
-			put_user((p[0] & 0x80003fff) | (nType << 14), &pMem[0]);
+			put_user((p[0] & 0x80003fff) | (nType << 14), pMem);
 		}
 		break;
 #endif
