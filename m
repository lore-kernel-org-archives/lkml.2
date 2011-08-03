Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab1HCXgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:36:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab1HCXaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:53 2011
Message-Id: <20110803221253.754676040@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [096/102] GFS2: Fix mount hang caused by certain access pattern to sysfs files
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit 19237039919088781b4191a00bdc1284d8fea1dd upstream.

Depending upon the order of userspace/kernel during the
mount process, this can result in a hang without the
_all version of the completion.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/gfs2/ops_fstype.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1018,13 +1018,13 @@ hostdata_error:
 		fsname++;
 	if (lm->lm_mount == NULL) {
 		fs_info(sdp, "Now mounting FS...\n");
-		complete(&sdp->sd_locking_init);
+		complete_all(&sdp->sd_locking_init);
 		return 0;
 	}
 	ret = lm->lm_mount(sdp, fsname);
 	if (ret == 0)
 		fs_info(sdp, "Joined cluster. Now mounting FS...\n");
-	complete(&sdp->sd_locking_init);
+	complete_all(&sdp->sd_locking_init);
 	return ret;
 }
 


