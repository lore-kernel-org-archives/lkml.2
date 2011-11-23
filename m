Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163Ab1KWAiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:38:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759126Ab1KWAha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:37:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:57 2011
Message-Id: <20111123002557.714719173@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: [51/53] batman-adv: add sanity check when removing global tts
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>

commit 6e8014947d6469df1566e9e253805557c5c0e4e0 upstream.

After removing the batman-adv module, the hash may be already gone
when tt_global_del_orig() tries to clean the hash. This patch adds
a sanity check to avoid this.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Tested-by: Alexey Fisher <bug-track@fisher-privat.net>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/batman-adv/translation-table.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -698,6 +698,9 @@ void tt_global_del_orig(struct bat_priv
 	struct hlist_head *head;
 	spinlock_t *list_lock; /* protects write access to the hash lists */
 
+	if (!hash)
+		return;
+
 	for (i = 0; i < hash->size; i++) {
 		head = &hash->table[i];
 		list_lock = &hash->list_locks[i];


