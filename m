Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab0G3RTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:17 -0400
Received: from kroah.org ([198.145.64.141]:51771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab0G3RTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:07 2010
Message-Id: <20100730171507.366507194@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [085/165] ext4: return correct wbc.nr_to_write in ext4_da_writepages
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 2faf2e19dd0e060eeb32442858ef495ac3083277 upstream (as of v2.6.33-rc3)

When ext4_da_writepages increases the nr_to_write in writeback_control
then it must always re-base the return value.  Originally there was a
(misguided) attempt prevent wbc.nr_to_write from going negative.  In
fact, it's necessary to allow nr_to_write to be negative so that
wb_writeback() can correctly calculate how many pages were actually
written.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3010,8 +3010,7 @@ retry:
 out_writepages:
 	if (!no_nrwrite_index_update)
 		wbc->no_nrwrite_index_update = 0;
-	if (wbc->nr_to_write > nr_to_writebump)
-		wbc->nr_to_write -= nr_to_writebump;
+	wbc->nr_to_write -= nr_to_writebump;
 	wbc->range_start = range_start;
 	trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
 	return ret;


