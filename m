Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965309Ab2C3WKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:10:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965223Ab2C3VPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:15:16 -0400
Message-Id: <20120330194900.601009004@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Andrei Warkentin <andrey.warkentin@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 124/149] dm exception store: fix init error path
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Warkentin <andrey.warkentin@gmail.com>

commit aadbe266f2f89ccc68b52f4effc7b3a8b29521ef upstream.

Call the correct exit function on failure in dm_exception_store_init.

Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-exception-store.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -283,7 +283,7 @@ int dm_exception_store_init(void)
 	return 0;
 
 persistent_fail:
-	dm_persistent_snapshot_exit();
+	dm_transient_snapshot_exit();
 transient_fail:
 	return r;
 }


