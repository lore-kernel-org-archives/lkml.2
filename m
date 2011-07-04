Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab1GDRKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:10:20 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:41604 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab1GDRKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:10:06 -0400
Message-Id: <20110704170959.567602717@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Mon, 04 Jul 2011 19:09:28 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: ebiederm@xmission.com, vgoyal@redhat.com, hbabu@us.ibm.com,
        mahesh@linux.vnet.ibm.com
Cc: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 6/9] kdump: Merge set_vmcore_list_offsets_elf_32/64()
References: <20110704170922.976299676@linux.vnet.ibm.com>
Content-Disposition: inline; filename=06-s390-kdump-common-vmcore-merge-set_vmcore_list_offsets.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

The two functions set_vmcore_list_offsets_elf_32/64() are identical now
for 32 and 64 bit. Therefore this patch merges them into one
set_vmcore_list_offsets() function.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c |   28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -490,24 +490,8 @@ static int __init process_ptload_program
 }
 
 /* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf64(char *elfptr,
-						struct list_head *vc_list)
-{
-	loff_t vmcore_off;
-	struct vmcore *m;
-
-	/* Skip Elf header and program headers. */
-	vmcore_off = elfcorebuf_sz;
-
-	list_for_each_entry(m, vc_list, list) {
-		m->offset = vmcore_off;
-		vmcore_off += m->size;
-	}
-}
-
-/* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf32(char *elfptr,
-						struct list_head *vc_list)
+static void __init set_vmcore_list_offsets(char *elfptr,
+					   struct list_head *vc_list)
 {
 	loff_t vmcore_off;
 	struct vmcore *m;
@@ -573,7 +557,7 @@ static int __init parse_crash_elf64_head
 		kfree(elfcorebuf);
 		return rc;
 	}
-	set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets(elfcorebuf, &vmcore_list);
 	return 0;
 }
 
@@ -629,7 +613,7 @@ static int __init parse_crash_elf32_head
 		kfree(elfcorebuf);
 		return rc;
 	}
-	set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets(elfcorebuf, &vmcore_list);
 	return 0;
 }
 
@@ -701,7 +685,7 @@ static int __init parse_crash_elf_header
 							  &vmcore_list);
 		if (rc)
 			goto fail;
-		set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
+		set_vmcore_list_offsets(elfcorebuf, &vmcore_list);
 		vmcore_size = get_vmcore_size_elf64(elfcorebuf);
 	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
 		rc = process_ptload_program_headers_elf32(elfcorebuf,
@@ -709,7 +693,7 @@ static int __init parse_crash_elf_header
 							  &vmcore_list);
 		if (rc)
 			goto fail;
-		set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
+		set_vmcore_list_offsets(elfcorebuf, &vmcore_list);
 		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
 	}
 	return 0;

