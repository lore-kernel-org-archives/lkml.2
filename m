Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992816Ab2KOEnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:43:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:48655 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992795Ab2KOEKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:10:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mark Tinguely <tinguely@sgi.com>, Ben Myers <bpm@sgi.com>
Subject: [ 37/38] xfs: fix reading of wrapped log data
Date: Wed, 14 Nov 2012 20:10:34 -0800
Message-Id: <20121115040935.184083496@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040932.918082372@linuxfoundation.org>
References: <20121115040932.918082372@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 6ce377afd1755eae5c93410ca9a1121dfead7b87 upstream.

Commit 4439647 ("xfs: reset buffer pointers before freeing them") in
3.0-rc1 introduced a regression when recovering log buffers that
wrapped around the end of log. The second part of the log buffer at
the start of the physical log was being read into the header buffer
rather than the data buffer, and hence recovery was seeing garbage
in the data buffer when it got to the region of the log buffer that
was incorrectly read.

Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_log_recover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3512,7 +3512,7 @@ xlog_do_recovery_pass(
 				 *   - order is important.
 				 */
 				error = xlog_bread_offset(log, 0,
-						bblks - split_bblks, hbp,
+						bblks - split_bblks, dbp,
 						offset + BBTOB(split_bblks));
 				if (error)
 					goto bread_err2;


