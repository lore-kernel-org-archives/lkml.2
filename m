Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab1KWAg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:36:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab1KWAg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:36:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:57 2011
Message-Id: <20111123002557.806616502@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Antonio Quartulli <ordex@autistici.org>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: [52/53] batman-adv: unify hash_entry field position in tt_local/global_entry
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <ordex@autistici.org>

commit 93840ac40bb0d0f177ef8af74e64671be67e8c37 upstream.

Function tt_response_fill_table() actually uses a tt_local_entry pointer to
iterate either over the local or the global table entries (it depends on the
what hash table is passed as argument). To iterate over such entries the
hlist_for_each_entry_rcu() macro has to access their "hash_entry" field which
MUST be at the same position in both the tt_global/local_entry structures.

Reported-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/batman-adv/types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -223,22 +223,22 @@ struct socket_packet {
 
 struct tt_local_entry {
 	uint8_t addr[ETH_ALEN];
+	struct hlist_node hash_entry;
 	unsigned long last_seen;
 	uint16_t flags;
 	atomic_t refcount;
 	struct rcu_head rcu;
-	struct hlist_node hash_entry;
 };
 
 struct tt_global_entry {
 	uint8_t addr[ETH_ALEN];
+	struct hlist_node hash_entry; /* entry in the global table */
 	struct orig_node *orig_node;
 	uint8_t ttvn;
 	uint16_t flags; /* only TT_GLOBAL_ROAM is used */
 	unsigned long roam_at; /* time at which TT_GLOBAL_ROAM was set */
 	atomic_t refcount;
 	struct rcu_head rcu;
-	struct hlist_node hash_entry; /* entry in the global table */
 };
 
 struct tt_change_node {


