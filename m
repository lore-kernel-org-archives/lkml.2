Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2GQWj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:39:56 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39611 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221Ab2GQWjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:39:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 06/17] xen-blkfront: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:25 -0400
Message-Id: <1342560756-18737-7-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1342560756-18737-1-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
no-op; interrupt randomness is now collected unconditionally in a very
low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
flag was scheduled to be removed in 2009 on the
feature-removal-schedule, so this patch is preparation for the final
removal of this flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/block/xen-blkfront.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 60eed4b..8f7a071 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -854,9 +854,8 @@ static int setup_blkring(struct xenbus_device *dev,
 	if (err)
 		goto fail;
 
-	err = bind_evtchn_to_irqhandler(info->evtchn,
-					blkif_interrupt,
-					IRQF_SAMPLE_RANDOM, "blkif", info);
+	err = bind_evtchn_to_irqhandler(info->evtchn, blkif_interrupt, 0,
+					"blkif", info);
 	if (err <= 0) {
 		xenbus_dev_fatal(dev, err,
 				 "bind_evtchn_to_irqhandler failed");
-- 
1.7.11.1.108.gb129051

