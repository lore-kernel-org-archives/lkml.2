Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031650Ab2CITwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:52:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031603Ab2CITwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:52:16 -0500
Message-Id: <20120309190216.984045409@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Subject: [ 25/68] NOMMU: Dont need to clear vm_mm when deleting a VMA
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit b94cfaf6685d691dc3fab023cf32f65e9b7be09c upstream.

Don't clear vm_mm in a deleted VMA as it's unnecessary and might
conceivably break the filesystem or driver VMA close routine.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/nommu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -780,8 +780,6 @@ static void delete_vma_from_mm(struct vm
 
 	if (vma->vm_next)
 		vma->vm_next->vm_prev = vma->vm_prev;
-
-	vma->vm_mm = NULL;
 }
 
 /*


