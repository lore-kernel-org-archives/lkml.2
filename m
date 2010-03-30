Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0C3XIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:08:48 -0400
Received: from kroah.org ([198.145.64.141]:48347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0C3XIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:47 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:40 2010
Message-Id: <20100330224939.989304996@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mika Westerberg <ext-mika.1.westerberg@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [01/45] UBI: fix volume creation input checking
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mika Westerberg <ext-mika.1.westerberg@nokia.com>

commit c5ce5b46af76f52dea21f467397d24c4ae6cb3ff upstream.

Do not use an unchecked variable UBI_IOCMKVOL ioctl.

Signed-off-by: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/cdev.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -793,7 +793,6 @@ static int ubi_cdev_ioctl(struct inode *
 			break;
 		}
 
-		req.name[req.name_len] = '\0';
 		err = verify_mkvol_req(ubi, &req);
 		if (err)
 			break;


