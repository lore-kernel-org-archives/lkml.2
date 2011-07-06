Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1GFL0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:26:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab1GFL0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:26:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FDPIC: Fix memory leak
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        uclinux-dev@uclinux.org, Davidlohr Bueso <dave@gnu.org>,
        David Howells <dhowells@redhat.com>
Date: Wed, 06 Jul 2011 12:26:05 +0100
Message-ID: <20110706112604.29112.39546.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

The shdr4extnum variable isn't being freed in the cleanup process of
elf_fdpic_core_dump().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/binfmt_elf_fdpic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 63039ed..2bc5dc6 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1864,6 +1864,7 @@ cleanup:
 	kfree(psinfo);
 	kfree(notes);
 	kfree(fpu);
+	kfree(shdr4extnum);
 #ifdef ELF_CORE_COPY_XFPREGS
 	kfree(xfpu);
 #endif

