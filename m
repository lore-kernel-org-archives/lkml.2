Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032006Ab2CITyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:54:47 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52821 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031951Ab2CITym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:54:42 -0500
Message-Id: <20120309190220.247833047@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Brassow <jbrassow@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 66/68] dm raid: fix flush support
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan E Brassow <jbrassow@redhat.com>

commit 0ca93de9b789e0eb05e103f0c04de72df13da73a upstream.

Fix dm-raid flush support.

Both md and dm have support for flush, but the dm-raid target
forgot to set the flag to indicate that flushes should be
passed on.  (Important for data integrity e.g. with writeback cache
enabled.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-raid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -468,6 +468,7 @@ static int raid_ctr(struct dm_target *ti
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->split_io = rs->md.chunk_sectors;
 	ti->private = rs;
+	ti->num_flush_requests = 1;
 
 	mutex_lock(&rs->md.reconfig_mutex);
 	ret = md_run(&rs->md);


