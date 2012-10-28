Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2J1XeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:34:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42186 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756989Ab2J1X2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:24 -0400
Message-Id: <20121028231549.451898184@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>, NeilBrown <neilb@suse.de>
Subject: [ 040/105] md/raid10: use correct limit variable
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 91502f099dfc5a1e8812898e26ee280713e1d002 upstream.

Clang complains that we are assigning a variable to itself.  This should
be using bad_sectors like the similar earlier check does.

Bug has been present since 3.1-rc1.  It is minor but could
conceivably cause corruption or other bad behaviour.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 146749b..867d1b4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3218,7 +3218,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				else {
 					bad_sectors -= (sector - first_bad);
 					if (max_sync > bad_sectors)
-						max_sync = max_sync;
+						max_sync = bad_sectors;
 					continue;
 				}
 			}


