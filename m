Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1GHFEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab1GHFEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:00 2011
Message-Id: <20110708001700.143180263@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [076/107] cfq-iosched: make code consistent
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 726e99ab88db059fe1422e15376ae404f8c66eb4 upstream.

ioc->ioc_data is rcu protectd, so uses correct API to access it.
This doesn't change any behavior, but just make code consistent.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3018,7 +3018,8 @@ cfq_drop_dead_cic(struct cfq_data *cfqd,
 
 	spin_lock_irqsave(&ioc->lock, flags);
 
-	BUG_ON(ioc->ioc_data == cic);
+	BUG_ON(rcu_dereference_check(ioc->ioc_data,
+		lockdep_is_held(&ioc->lock)) == cic);
 
 	radix_tree_delete(&ioc->radix_root, cfqd->cic_index);
 	hlist_del_rcu(&cic->cic_list);


