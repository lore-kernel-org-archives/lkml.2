Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1KCBc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:32:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1KCBcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:32:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:51 2011
Message-Id: <20111102221451.295943500@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [013/107] md/linear: avoid corrupting structure while waiting for rcu_free to complete.
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 1b6afa17581027218088a18a9ceda600e0ddba7a upstream.

I don't know what I was thinking putting 'rcu' after a dynamically
sized array!  The array could still be in use when we call rcu_free()
(That is the point) so we mustn't corrupt it.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/linear.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/linear.h
+++ b/drivers/md/linear.h
@@ -10,9 +10,9 @@ typedef struct dev_info dev_info_t;
 
 struct linear_private_data
 {
+	struct rcu_head		rcu;
 	sector_t		array_sectors;
 	dev_info_t		disks[0];
-	struct rcu_head		rcu;
 };
 
 


