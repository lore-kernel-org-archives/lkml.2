Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030261Ab2CITup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:50:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031287Ab2CITuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:40 -0500
Message-Id: <20120309190209.690711017@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Brassow <jbrassow@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 92/95] dm raid: fix flush support
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -974,6 +974,7 @@ static int raid_ctr(struct dm_target *ti
 
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
+	ti->num_flush_requests = 1;
 
 	mutex_lock(&rs->md.reconfig_mutex);
 	ret = md_run(&rs->md);


