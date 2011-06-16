Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab1FPHLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:22 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58639 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757001Ab1FPHLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:13 -0400
X-Sasl-enc: xzh9A3nrby7Y06Qpw+dfuNYuHuMKMxix52XQTNKaHmtk 1308208272
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:10 2011
Message-Id: <20110616002910.255317731@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [64/85] fat: Fix corrupt inode flags when remove ATTR_SYS flag
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 1adffbae22332bb558c2a29de19d9aca391869f6 upstream.

We are clearly missing '~' in fat_ioctl_set_attributes().

Reported-by: Dmitry Dmitriev <dimondmm@yandex.ru>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fat/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -101,7 +101,7 @@ static int fat_ioctl_set_attributes(stru
 		if (attr & ATTR_SYS)
 			inode->i_flags |= S_IMMUTABLE;
 		else
-			inode->i_flags &= S_IMMUTABLE;
+			inode->i_flags &= ~S_IMMUTABLE;
 	}
 
 	fat_save_attrs(inode, attr);


