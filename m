Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937Ab1KCBnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:43:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934902Ab1KCBnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:43:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:48 2011
Message-Id: <20111102222748.184612371@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <error27@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Leonardo Chiquitto <leonardo.lists@gmail.com>
Subject: [092/101] kcore: fix test for end of list
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 4fd2c20d964a8fb9861045f1022475c9d200d684 upstream.

"m" is never NULL here.  We need a different test for the end of list
condition.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Leonardo Chiquitto <leonardo.lists@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -490,7 +490,7 @@ read_kcore(struct file *file, char __use
 		}
 		read_unlock(&kclist_lock);
 
-		if (m == NULL) {
+		if (&m->list == &kclist_head) {
 			if (clear_user(buffer, tsz))
 				return -EFAULT;
 		} else if (is_vmalloc_or_module_addr((void *)start)) {


