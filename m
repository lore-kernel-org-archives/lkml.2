Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0DZNw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:52:57 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:38263 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822Ab0DZNw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:52:56 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2010 09:52:55 EDT
Date: Mon, 26 Apr 2010 15:44:35 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
       David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       Mike Frysinger <vapier@gentoo.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] Doublecheck for CONFIG_MMU
Message-ID: <20100426134435.GA2710@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	The following patch removes a unnecessary conditional. Inside
a block making sure CONFIG_MMU isn't set the option is checked again
and based on that some parts are (not) included. As the outer check
already makes sure CONFIG_MMU isn't set here both checks are
unnecessary so this patch removes them.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From 641fdd413e19208abfd764e061c8bbddeb24d574 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Mon, 26 Apr 2010 15:32:53 +0200
Subject: [PATCH] Remove redundant check for CONFIG_MMU

The checks for CONFIG_MMU at this location is duplicated as all the
code is located inside a #ifndef CONFIG_MMU block. So the first
Conditional Block will always be included while the second will never.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
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
-- 
1.6.3.3







