Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031284Ab2CITuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:50:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031240Ab2CITud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:33 -0500
Message-Id: <20120309190209.543582565@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 90/95] dm thin metadata: decrement counter after removing mapped block
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit af63bcb817cf708f53bcae6edc2e3fb7dd7d8051 upstream.

Correct the number of mapped sectors shown on a thin device's
status line by decrementing td->mapped_blocks in __remove() each time
a block is removed.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin-metadata.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1224,6 +1224,8 @@ static int __remove(struct dm_thin_devic
 	if (r)
 		return r;
 
+	td->mapped_blocks--;
+	td->changed = 1;
 	pmd->need_commit = 1;
 
 	return 0;


