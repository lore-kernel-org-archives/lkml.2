Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0CPLsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:48:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab0CPLsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:48:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Fix an incorrect comment in the do_mmap_shared_file()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Mar 2010 11:47:56 +0000
Message-ID: <20100316114756.25541.67197.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an incorrect comment in the do_mmap_shared_file().  If a mapping is
requested MAP_SHARED, then a private copy cannot be made and still provide
correct semantics.

Reported-by: Dave Hudson <uclinux@blueteddy.net>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/nommu.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index 605ace8..e4b8f4d 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1040,10 +1040,9 @@ static int do_mmap_shared_file(struct vm_area_struct *vma)
 	if (ret != -ENOSYS)
 		return ret;
 
-	/* getting an ENOSYS error indicates that direct mmap isn't
-	 * possible (as opposed to tried but failed) so we'll fall
-	 * through to making a private copy of the data and mapping
-	 * that if we can */
+	/* getting -ENOSYS indicates that direct mmap isn't possible (as
+	 * opposed to tried but failed) so we can only give a suitable error as
+	 * it's not possible to make a private copy if MAP_SHARED was given */
 	return -ENODEV;
 }
 

