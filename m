Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946936Ab2ERXQC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:16:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38665 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946650Ab2ERXGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:06:18 -0400
Message-Id: <20120518212650.137110817@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:26:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 10/47] ARM: prevent VM_GROWSDOWN mmaps extending below FIRST_USER_ADDRESS
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 9b61a4d1b2064dbd0c9e61754305ac852170509f upstream.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/fault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -245,7 +245,9 @@ good_area:
 	return handle_mm_fault(mm, vma, addr & PAGE_MASK, flags);
 
 check_stack:
-	if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, addr))
+	/* Don't allow expansion below FIRST_USER_ADDRESS */
+	if (vma->vm_flags & VM_GROWSDOWN &&
+	    addr >= FIRST_USER_ADDRESS && !expand_stack(vma, addr))
 		goto good_area;
 out:
 	return fault;


