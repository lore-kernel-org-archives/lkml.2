Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab2EJVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:09:57 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:41815 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757552Ab2EJVJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:09:54 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-parisc@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: [PATCH 4/5] parisc: add missing include of asm/page.h to asm/pgtable.h
Date: Thu, 10 May 2012 23:07:16 +0200
Message-ID: <4289546.1CNkXRDMmz@donald.sf-tec.de>
User-Agent: KMail/4.8.3 (Linux/3.2.9-13-desktop; KDE/4.8.3; i686; ; )
In-Reply-To: <4430485.xEvkeJU8MB@donald.sf-tec.de>
References: <4430485.xEvkeJU8MB@donald.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes these errors:

In file included from /home/buildbot/repos/linux/arch/parisc/include/asm/io.h:5:0,
                 from /home/buildbot/repos/linux/include/linux/io.h:22,
                 from /home/buildbot/repos/linux/include/linux/pci.h:54,
                 from /home/buildbot/repos/linux/arch/parisc/kernel/setup.c:35:
/home/buildbot/repos/linux/arch/parisc/include/asm/pgtable.h:92:6: warning: "PAGE_SHIFT" is not defined [-Wundef]
/home/buildbot/repos/linux/arch/parisc/include/asm/pgtable.h:92:6: warning: "PAGE_SHIFT" is not defined [-Wundef]
/home/buildbot/repos/linux/arch/parisc/include/asm/pgtable.h:92:6: warning: "BITS_PER_PTE_ENTRY" is not defined [-Wundef]

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 arch/parisc/include/asm/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index 22dadeb..ee99f23 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -44,6 +44,8 @@ struct vm_area_struct;
 
 #endif /* !__ASSEMBLY__ */
 
+#include <asm/page.h>
+
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pmd_ERROR(e) \
-- 
1.7.9.2


