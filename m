Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab1KWAhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:37:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759057Ab1KWAhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:37:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:57 2011
Message-Id: <20111123002557.423041928@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Antonio Quartulli <ordex@autistici.org>,
        Junkeun Song <jun361@gmail.com>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: [48/53] batman-adv: fix tt_local_reset_flags() function
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <ordex@autistici.org>

commit 31901264511cf20c5ed33b8649a3ca9ce28df60b upstream.

Currently the counter of tt_local_entry structures (tt_local_num) is incremented
each time the tt_local_reset_flags() is invoked causing the node to send wrong
TT_REPONSE packets containing a copy of non-initialised memory thus corrupting
other nodes global translation table and making higher level communication
impossible.

Reported-by: Junkeun Song <jun361@gmail.com>
Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Acked-by: Junkeun Song <jun361@gmail.com>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/batman-adv/translation-table.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1668,6 +1668,8 @@ static void tt_local_reset_flags(struct
 		rcu_read_lock();
 		hlist_for_each_entry_rcu(tt_local_entry, node,
 					 head, hash_entry) {
+			if (!(tt_local_entry->flags & flags))
+				continue;
 			tt_local_entry->flags &= ~flags;
 			atomic_inc(&bat_priv->num_local_tt);
 		}


