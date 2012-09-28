Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032806Ab2I1VIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:08:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33268 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423187Ab2I1VF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:05:58 -0400
X-Sasl-enc: wdtgfX+O7X5DtZFmGZ1uCwd3CvK0LgFAL0f8iry+7Jqc 1348866357
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [ 118/127] Squashfs: fix mount time sanity check for corrupted superblock
Date: Fri, 28 Sep 2012 13:34:51 -0700
Message-Id: <20120928203059.719603885@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

commit cc37f75a9ffbbfcb1c3297534f293c8284e3c5a6 upstream.

A Squashfs filesystem containing nothing but an empty directory,
although unusual and ultimately pointless, is still valid.

The directory_table >= next_table sanity check rejects these
filesystems as invalid because the directory_table is empty and
equal to next_table.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/squashfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -290,7 +290,7 @@ handle_fragments:
 
 check_directory_table:
 	/* Sanity check directory_table */
-	if (msblk->directory_table >= next_table) {
+	if (msblk->directory_table > next_table) {
 		err = -EINVAL;
 		goto failed_mount;
 	}


