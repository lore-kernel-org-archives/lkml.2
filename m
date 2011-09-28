Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1I1XXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:23:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1I1WlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:33 2011
Message-Id: <20110928220133.752576862@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [080/244] net/9p: fix client code to fail more gracefully on protocol error
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Van Hensbergen <ericvh@gmail.com>

commit b85f7d92d7bd7e3298159e8b1eed8cb8cbbb0348 upstream.

There was a BUG_ON to protect against a bad id which could be dealt with
more gracefully.

Reported-by: Natalie Orlin <norlin@us.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/9p/client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -280,7 +280,8 @@ struct p9_req_t *p9_tag_lookup(struct p9
 	 * buffer to read the data into */
 	tag++;
 
-	BUG_ON(tag >= c->max_tag);
+	if(tag >= c->max_tag)
+		return NULL;
 
 	row = tag / P9_ROW_MAXTAG;
 	col = tag % P9_ROW_MAXTAG;


