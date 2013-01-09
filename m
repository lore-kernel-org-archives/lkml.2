Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab3AIUkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:40:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:43586 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933852Ab3AIUkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 081/123] sparc64: Fix ECB looping constructs in AES code.
Date: Wed,  9 Jan 2013 12:35:20 -0800
Message-Id: <20130109201508.996897708@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit ce6889515d5d481a5bd8ce5913dfed18f08310ea ]

Things works better when you increment the source buffer pointer
properly.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/crypto/des_asm.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/crypto/des_asm.S
+++ b/arch/sparc/crypto/des_asm.S
@@ -376,6 +376,7 @@ ENTRY(des3_ede_sparc64_ecb_crypt)
 1:	ldd	[%o1 + 0x00], %f60
 	DES3_LOOP_BODY(60)
 	std	%f60, [%o2 + 0x00]
+	add	%o1, 0x08, %o1
 	subcc	%o3, 0x08, %o3
 	bne,pt	%icc, 1b
 	 add	%o2, 0x08, %o2


