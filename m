Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1FEQaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:30:55 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59444 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1FEQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:30:46 -0400
Subject: [PATCH 1/5] CFQ: make two functions static
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Date: Sun, 05 Jun 2011 18:26:23 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307291188.8545.42.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly suggested by sparse.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 block/cfq-iosched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3b87b95..79606f9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1006,8 +1006,8 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 	return NULL;
 }
 
-void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
-					unsigned int weight)
+static void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
+					  unsigned int weight)
 {
 	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
 	cfqg->new_weight = weight;
@@ -1165,7 +1165,7 @@ static void cfq_release_cfq_groups(struct cfq_data *cfqd)
  * it should not be NULL as even if elevator was exiting, cgroup deltion
  * path got to it first.
  */
-void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
+static void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 {
 	unsigned long  flags;
 	struct cfq_data *cfqd = key;
-- 
1.7.5.2




