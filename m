Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1CYOi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:38:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65330 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1CYOi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bxt0CsalF/QxENOsBAvcLiC09p6u/wMtiDN4V8zy8dNOll8ZxNRV+Ms9rXVbW3DKQB
         JpfDe0elzUfK52qX6FELz+eDNGl/mdNXIlkgG3/710tFOMSqUlKxsjinrlBXlFZt1YFD
         77rIBX7neZAKh+tTANLlMpIXjvmqrDxHY3wq4=
Date: Fri, 25 Mar 2011 15:38:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>, Milton Miller <miltonm@bga.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, David Cross <david.cross@cypress.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: Fix bdops->check_events() misconversion in
 cyasblkdev_block.c
Message-ID: <20110325143822.GE1409@htj.dyndns.org>
References: <check-events-cyasblkdev-block-suspect@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <check-events-cyasblkdev-block-suspect@mdm.bga.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cafb0bfca1 (staging: Convert to bdops->check_events())
incorrectly set bd->user_disk_0->events while initializing
bd->user_disk_1.  Fix it.

The problem was spotted by Milton's suspect code pattern detector.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Milton Miller <miltonm@bga.com>
---
Nice spotting Milton.  Thank you.

 drivers/staging/westbridge/astoria/block/cyasblkdev_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
index 842cd92..289729d 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
@@ -1191,7 +1191,7 @@ static int cyasblkdev_add_disks(int bus_num,
 		bd->user_disk_1->first_minor = (devidx + 1) << CYASBLKDEV_SHIFT;
 		bd->user_disk_1->minors = 8;
 		bd->user_disk_1->fops = &cyasblkdev_bdops;
-		bd->user_disk_0->events = DISK_EVENT_MEDIA_CHANGE;
+		bd->user_disk_1->events = DISK_EVENT_MEDIA_CHANGE;
 		bd->user_disk_1->private_data = bd;
 		bd->user_disk_1->queue = bd->queue.queue;
 		bd->dbgprn_flags = DBGPRN_RD_RQ;
