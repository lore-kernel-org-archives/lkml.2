Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1G1P4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:56:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab1G1P4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:56:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 39/40] UAPI: Fix the x86 test_get_len tool [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:55:33 +0100
Message-ID: <20110728155533.16618.3273.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the x86 test_get_len tool to have the right include paths in the right
order (it includes a non-exported kernel header directly), otherwise errors
like the following occur:

/data/fs/linux-2.6-hdr/include/linux/types.h:18:26: error: conflicting types for 'fd_set'
/usr/include/sys/select.h:78:5: note: previous declaration of 'fd_set' was here

and

/data/fs/linux-2.6-hdr/include/linux/string.h:42:12: error: expected identifier or '(' before '__extension__'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/tools/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index f820826..69c3017 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -24,7 +24,7 @@ posttest: $(obj)/test_get_len vmlinux
 hostprogs-y	:= test_get_len
 
 # -I needed for generated C source and C source which in the kernel tree.
-HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/
+HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/uapi/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/uapi/
 
 # Dependencies are also needed.
 $(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c

