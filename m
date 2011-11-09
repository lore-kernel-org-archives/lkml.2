Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936046Ab1KJDoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:44:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965622Ab1KJDoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:44:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:57 2011
Message-Id: <20111109213157.697861520@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Jones <davej@redhat.com>,
        Richard Weinberger <richard@nod.at>
Subject: [154/264] um: Fix kmalloc argument order in um/vdso/vma.c
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

commit 0d65ede0a605d6252acc5c8a9c536c4cd0211f3c upstream.

kmalloc size is 1st arg, not second.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/sys-x86_64/vdso/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/sys-x86_64/vdso/vma.c
+++ b/arch/um/sys-x86_64/vdso/vma.c
@@ -28,7 +28,7 @@ static int __init init_vdso(void)
 
 	um_vdso_addr = task_size - PAGE_SIZE;
 
-	vdsop = kmalloc(GFP_KERNEL, sizeof(struct page *));
+	vdsop = kmalloc(sizeof(struct page *), GFP_KERNEL);
 	if (!vdsop)
 		goto oom;
 


