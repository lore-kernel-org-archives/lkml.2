Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161583Ab2COU4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:56:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161544Ab2COU4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:56:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/38] Fix c6x's entry.S [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>
Date: Thu, 15 Mar 2012 20:56:30 +0000
Message-ID: <20120315205630.28759.13538.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ENDPROC() on sys_fadvise64_c6x() in arch/c6x/kernel/entry.S needs to be
transposed with the preceding #endif so that it's in the same conditional
block as the matching ENTRY() macro.

Without this, I see:

/tmp/ccGZBaPT.s: Assembler messages:
/tmp/ccGZBaPT.s: Error: .size expression for sys_fadvise64_c6x does not evaluate to a constant

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/c6x/kernel/entry.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/c6x/kernel/entry.S b/arch/c6x/kernel/entry.S
index 3e977cc..91b2e79 100644
--- a/arch/c6x/kernel/entry.S
+++ b/arch/c6x/kernel/entry.S
@@ -741,8 +741,8 @@ ENTRY(sys_fadvise64_c6x)
 #endif
 	MV	.D1X	B6,A6
 	MV	.D2X	A8,B6
-#endif
 ENDPROC(sys_fadvise64_c6x)
+#endif
 
 ;; On Entry
 ;;   A4 - fd

