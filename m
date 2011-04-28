Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab1D1I2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:28:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38821 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab1D1I2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jos8PLvVPpIiZ2P9PAtGKLPBofFRwp6FDjmU6uOttfBgTIj6FM2MFJoghce3/HFed0
         QoUn+NFvkyzPEy/gfqQ0xv0dbkaAHy/PHxIZczRI8M6FLICaH1FquXNFb96V4l4Z3wko
         VwVAHMmquWKLR9yeeodm3fHqJxFliDALEJ2yA=
From: Lifeng Sun <lifongsun@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lifeng Sun <lifongsun@gmail.com>
Subject: [PATCH 2/5] vfs: inappropriate ioctl operation on pipe/fifo should return ENOTTY
Date: Thu, 28 Apr 2011 16:28:08 +0800
Message-Id: <1303979288-30171-1-git-send-email-lifongsun@gmail.com>
X-Mailer: git-send-email 1.7.5.rc1
In-Reply-To: <1303977891-29280-1-git-send-email-lifongsun@gmail.com>
References: <1303977891-29280-1-git-send-email-lifongsun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctl() calls against a pipe or fifo with an inappropriate ioctl
operation are incorrectly returning EINVAL rather than ENOTTY:

  [ENOTTY]
      Inappropriate I/O control operation.

Signed-off-by: Lifeng Sun <lifongsun@gmail.com>
---
 fs/pipe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index da42f7d..fe7ffe4 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -665,7 +665,7 @@ static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 			return put_user(count, (int __user *)arg);
 		default:
-			return -EINVAL;
+			return -ENOTTY;
 	}
 }
 
-- 
1.7.5.rc1

