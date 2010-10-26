Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab0JZCxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:53:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895Ab0JZCxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:53:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 07/43] MN10300: Don't cast away the volatile in test_bit()
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:53:39 +0100
Message-ID: <20101026025339.23512.14074.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Don't cast away the volatile in test_bit()'s parameter when we change its type
from const volatile void * so that we can dereference it.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/bitops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
index 6208ea6..3b8a868 100644
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -72,7 +72,7 @@ static inline void __clear_bit(unsigned long nr, volatile void *addr)
  */
 static inline int test_bit(unsigned long nr, const volatile void *addr)
 {
-	return 1UL & (((const unsigned int *) addr)[nr >> 5] >> (nr & 31));
+	return 1UL & (((const volatile unsigned int *) addr)[nr >> 5] >> (nr & 31));
 }
 
 /*

