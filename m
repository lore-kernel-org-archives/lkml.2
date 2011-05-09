Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1EIF4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:56:43 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:39864 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751537Ab1EIF4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:56:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:X-Identified-User;
	b=rzvBfgxObN37SoE/LksYokmVRILDJI/xXXZSn1BA0JAsCau+QDNjnLr2VImid1Uld8Uo4fqlW/ZiP2DZz0L8nQT4nB99iXQbE5plL/qt6NlF2R8z/h1Q+HGT4hfhF8OE;
From: Tao Ma <tm@tao.ma>
To: axboe@kernel.dk
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the block tree
Date: Mon,  9 May 2011 13:55:37 +0800
Message-Id: <1304920537-3975-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110509134931.6d822e05.sfr@canb.auug.org.au>
References: <20110509134931.6d822e05.sfr@canb.auug.org.au>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Sorry for the trouble. Here is the fix.

>From 60bf0c0972c0d0d237e30e1f1c79356f4aefa138 Mon Sep 17 00:00:00 2001
From: Tao Ma <boyu.mt@taobao.com>
Date: Mon, 9 May 2011 13:39:49 +0800
Subject: [PATCH] block: Change wrong type cast in part_discard_alignment_show.

Use 'unsigned int' instead of 'unsigned long long' introduced by commit
"block: Remove extra discard_alignment from hd_struct".

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/partitions/check.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index b7e16bc..b2bae85 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -258,7 +258,7 @@ ssize_t part_discard_alignment_show(struct device *dev,
 	struct gendisk *disk = dev_to_disk(dev);
 
 	return sprintf(buf, "%u\n",
-		       (unsigned long long)queue_limit_discard_alignment(
+		       (unsigned int)queue_limit_discard_alignment(
 							&disk->queue->limits,
 							p->start_sect));
 }
-- 
1.7.4

