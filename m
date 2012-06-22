Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638Ab2FVQPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:15:15 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20975 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762513Ab2FVQPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:15:09 -0400
X-IronPort-AV: E=Sophos;i="4.77,459,1336363200"; 
   d="scan'208";a="199722625"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <tim@xen.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH WIP 4/6] xen/arm: implement hvm_op
Date: Fri, 22 Jun 2012 17:14:43 +0100
Message-ID: <1340381685-22529-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/hypercall.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
index 2fe7434..7503256 100644
--- a/arch/arm/include/asm/xen/hypercall.h
+++ b/arch/arm/include/asm/xen/hypercall.h
@@ -189,7 +189,7 @@ HYPERVISOR_event_channel_op(int cmd, void *arg)
 
 static inline unsigned long HYPERVISOR_hvm_op(int op, void *arg)
 {
-	return -ENOSYS;
+	return _hypercall2(int, HYPERCALL(hvm_op), op, arg);
 }
 
 	static inline int
-- 
1.7.2.5

