Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0HIKrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:47:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43309 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab0HIKrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=r7iCLEGJDmnk9FeH2eVSt5pBwea4cGZNet1ecbhwuFf0V7zvPCjGLNiyI7FyDY0BZo
         1gd168kHuHZB4epdzQMImuiWMYS5sdRFcrV40VEhihKj0MKYRzNf8Iwp5Mh8MH9/+MPh
         RDugY93R1neDgr1lVxWd3k2Pw3D5ihu8vxntM=
MIME-Version: 1.0
Date: Mon, 9 Aug 2010 11:47:48 +0100
Message-ID: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
Subject: [PATCH] Function btree_get_extent: Incorrect if-else if statement
From: =?ISO-8859-1?Q?Andr=E9_Nogueira?= <andre.neo.net@gmail.com>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The btree_get_extent function (in file disk-io.c) calls the
add_extent_mapping (in file extent_map.c). The add_extent_mapping
function can return two values: 0 or -EEXIST.

After the call, it is used an if-else if statement. If the result is
-EEXIST, the if statement is executed. If the result is 0, the else if
statement will not be executed because it is false.

Thank you.

Signed-off-by: Andre Nogueira <andre.neo.net@gmail.com>

---
 fs/btrfs/disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..76eb161 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -164,7 +164,7 @@ static struct extent_map *btree_get_extent(struct
inode *inode,
 						   failed_len);
 			ret = -EIO;
 		}
-	} else if (ret) {
+	} else {
 		free_extent_map(em);
 		em = NULL;
 	}
-- 
1.6.3.3
