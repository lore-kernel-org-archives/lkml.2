Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab0HCVeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:34:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41605 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab0HCVeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:34:18 -0400
Date: Tue, 3 Aug 2010 23:34:16 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/9] fs/dlm: Drop unnecessary null test
Message-ID: <Pine.LNX.4.64.1008032334010.20393@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

hlist_for_each_entry binds its first argument to a non-null value, and thus
any null test on the value of that argument is superfluous.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
iterator I;
expression x,E,E1,E2;
statement S,S1,S2;
@@

I(x,...) { <...
- (x != NULL) &&
  E
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/dlm/lowcomms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index c0d35c6..37a34c2 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -248,7 +248,7 @@ static struct connection *assoc2con(int assoc_id)
 
 	for (i = 0 ; i < CONN_HASH_SIZE; i++) {
 		hlist_for_each_entry(con, h, &connection_hash[i], list) {
-			if (con && con->sctp_assoc == assoc_id) {
+			if (con->sctp_assoc == assoc_id) {
 				mutex_unlock(&connections_lock);
 				return con;
 			}
