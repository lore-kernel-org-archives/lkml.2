Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2KVVR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:17:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:49626 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab2KVSks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 024/171] s390/gup: add missing TASK_SIZE check to get_user_pages_fast()
Date: Wed, 21 Nov 2012 16:39:30 -0800
Message-Id: <20121122004035.781823221@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit d55c4c613fc4d4ad2ba0fc6fa2b57176d420f7e4 upstream.

When walking page tables we need to make sure that everything
is within bounds of the ASCE limit of the task's address space.
Otherwise we might calculate e.g. a pud pointer which is not
within a pud and dereference it.
So check against TASK_SIZE (which is the ASCE limit) before
walking page tables.

Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -183,7 +183,7 @@ int get_user_pages_fast(unsigned long st
 	addr = start;
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 	end = start + len;
-	if (end < start)
+	if ((end < start) || (end > TASK_SIZE))
 		goto slow_irqon;
 
 	/*


