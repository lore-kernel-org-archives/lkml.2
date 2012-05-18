Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030913Ab2ERC6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:58:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40575 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030730Ab2ERCwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:50 -0400
Message-Id: <20120518023300.576497000@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 46/53] ARM: prevent VM_GROWSDOWN mmaps extending below FIRST_USER_ADDRESS
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 9b61a4d1b2064dbd0c9e61754305ac852170509f upstream.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/fault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux.orig/arch/arm/mm/fault.c
+++ linux/arch/arm/mm/fault.c
@@ -267,7 +267,9 @@
 	return fault;
 
 check_stack:
-	if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, addr))
+	/* Don't allow expansion below FIRST_USER_ADDRESS */
+	if (vma->vm_flags & VM_GROWSDOWN &&
+	    addr >= FIRST_USER_ADDRESS && !expand_stack(vma, addr))
 		goto good_area;
 out:
 	return fault;


