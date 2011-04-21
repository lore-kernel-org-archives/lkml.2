Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1DUQHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:07:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31287 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1DUQHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:07:47 -0400
Date: Thu, 21 Apr 2011 09:07:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] raid5: fix build error, sector_t usage
Message-Id: <20110421090726.fffd8a5f.randy.dunlap@oracle.com>
In-Reply-To: <20110421140109.GA16856@elte.hu>
References: <20110421140109.GA16856@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DB05649.001A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Change <sectors> from unsigned long long to sector_t.
This matches its source field.

ERROR: "__udivdi3" [drivers/md/raid456.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110421.orig/drivers/md/raid5.c
+++ linux-next-20110421/drivers/md/raid5.c
@@ -5678,7 +5678,7 @@ static void raid5_quiesce(mddev_t *mddev
 static void *raid45_takeover_raid0(mddev_t *mddev, int level)
 {
 	struct raid0_private_data *raid0_priv = mddev->private;
-	unsigned long long sectors;
+	sector_t sectors;
 
 	/* for raid0 takeover only one zone is supported */
 	if (raid0_priv->nr_strip_zones > 1) {
