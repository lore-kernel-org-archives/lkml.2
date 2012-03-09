Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab2CIUMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:12:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031251Ab2CITua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:30 -0500
Message-Id: <20120309190209.467644198@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 89/95] dm thin metadata: unlock superblock in init_pmd error path
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 4469a5f387fdde956894137751a41473618a4a52 upstream.

If dm_sm_disk_create() fails the superblock must be unlocked.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin-metadata.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -385,6 +385,7 @@ static int init_pmd(struct dm_pool_metad
 		data_sm = dm_sm_disk_create(tm, nr_blocks);
 		if (IS_ERR(data_sm)) {
 			DMERR("sm_disk_create failed");
+			dm_tm_unlock(tm, sblock);
 			r = PTR_ERR(data_sm);
 			goto bad;
 		}


