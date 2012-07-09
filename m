Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab2GIKjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:39:39 -0400
Received: from smtp.citrix.com ([66.165.176.89]:6124 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2GIKji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:39:38 -0400
X-IronPort-AV: E=Sophos;i="4.77,551,1336363200"; 
   d="scan'208";a="30818190"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86: add desc_equal() to compare GDT descriptors
Date: Mon, 9 Jul 2012 11:39:07 +0100
Message-ID: <1341830348-15529-4-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
References: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/include/asm/desc.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 8bf1c06..d26f059 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -85,6 +85,12 @@ static inline int desc_empty(const void *ptr)
 	return !(desc[0] | desc[1]);
 }
 
+static inline bool desc_equal(const struct desc_struct *d1,
+			      const struct desc_struct *d2)
+{
+	return d1->a == d2->a && d1->b == d2->b;
+}
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-- 
1.7.2.5

