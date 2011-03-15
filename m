Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1COWxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:53:32 -0400
Received: from shutemov.name ([188.40.19.243]:49771 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab1COWx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:27 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Viresh Kumar <viresh.kumar@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/13] plat-spear: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:14 +0200
Message-Id: <1300229605-14499-2-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/plat-spear/clock.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-spear/clock.c b/arch/arm/plat-spear/clock.c
index ee4f90e..1d24faf 100644
--- a/arch/arm/plat-spear/clock.c
+++ b/arch/arm/plat-spear/clock.c
@@ -267,9 +267,7 @@ static void change_parent(struct clk *cclk, struct clk *pclk)
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocks_lock, flags);
-	list_del(&cclk->sibling);
-	list_add(&cclk->sibling, &pclk->children);
-
+	list_move(&cclk->sibling, &pclk->children);
 	cclk->pclk = pclk;
 	spin_unlock_irqrestore(&clocks_lock, flags);
 }
-- 
1.7.4.1

