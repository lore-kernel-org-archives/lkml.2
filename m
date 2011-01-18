Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1AREPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 23:15:39 -0500
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:25935
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558Ab1AREPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 23:15:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALOgNE18qSwg/2dsb2JhbACEDKBKc7MsjwyBJIM4dASEbYlvgXI
X-IronPort-AV: E=Sophos;i="4.60,336,1291564800"; 
   d="scan'208";a="621913536"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 3/3] autofs4 - fix debug print in autofs4_lookup()
To: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 18 Jan 2011 12:06:15 +0800
Message-ID: <20110118040615.23109.54159.stgit@localhost6.localdomain6>
In-Reply-To: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
References: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oz_mode isn't defined any more, use autofs4_oz_mode(sbi) instead.
---

 fs/autofs4/root.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 1dba035..427129a 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -488,7 +488,8 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	sbi = autofs4_sbi(dir->i_sb);
 
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
-		current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
+		current->pid, task_pgrp_nr(current), sbi->catatonic,
+		autofs4_oz_mode(sbi));
 
 	active = autofs4_lookup_active(dentry);
 	if (active) {

