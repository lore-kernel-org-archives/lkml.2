Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0DZO5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab0DZO5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:57:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Remove redundant check for CONFIG_MMU
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, d.hatayama@jp.fujitsu.com, roland@redhat.com,
       vapier@gentoo.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de,
       Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       David Howells <dhowells@redhat.com>
Date: Mon, 26 Apr 2010 15:56:36 +0100
Message-ID: <20100426145636.7652.36480.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>

The checks for CONFIG_MMU at this location are duplicated as all the code is
located inside a #ifndef CONFIG_MMU block. So the first conditional block will
always be included while the second never will.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/binfmt_elf_fdpic.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 7ab23e0..2c5f9a0 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1005,15 +1005,8 @@ static int elf_fdpic_map_file_constdisp_on_uclinux(
 				}
 			} else if (!mm->start_data) {
 				mm->start_data = seg->addr;
-#ifndef CONFIG_MMU
 				mm->end_data = seg->addr + phdr->p_memsz;
-#endif
 			}
-
-#ifdef CONFIG_MMU
-			if (seg->addr + phdr->p_memsz > mm->end_data)
-				mm->end_data = seg->addr + phdr->p_memsz;
-#endif
 		}
 
 		seg++;

