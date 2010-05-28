Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab0E1Kws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:52:48 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:53826 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0E1Kwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:52:47 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] arch/um: fix kunmap_atomic call in skas/uaccess.c
Date: Fri, 28 May 2010 07:52:38 -0300
Message-Id: <1275043958-26495-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kunmap_atomic() takes a pointer to within the page, not the struct page.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 arch/um/kernel/skas/uaccess.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/kernel/skas/uaccess.c b/arch/um/kernel/skas/uaccess.c
index e22c969..6966342 100644
--- a/arch/um/kernel/skas/uaccess.c
+++ b/arch/um/kernel/skas/uaccess.c
@@ -81,7 +81,7 @@ static int do_op_one_page(unsigned long addr, int len, int is_write,
 
 	current->thread.fault_catcher = NULL;
 
-	kunmap_atomic(page, KM_UML_USERCOPY);
+	kunmap_atomic((void *)addr, KM_UML_USERCOPY);
 
 	return n;
 }
-- 
1.6.6.1

