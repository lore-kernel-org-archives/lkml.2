Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966015Ab0GPQOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:14:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43734 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965948Ab0GPQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=g4GregfL4QdDCtyE7bfTzzpRkgBEG0gyxw4TUu+gkndJiB9jHLHSuoiPRbQznzvDB9
         3Nn03jbaufFnG73BjR03nTNYXP7HkUJlrgj4Y3T02W3wrRYc+fPScnMUuHgirOyg76MS
         WTnNAFvkCi5aYgMfSHz5cdsRDwDsT/ITXRDkU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] staging: hv: check kzalloc() result
Date: Fri, 16 Jul 2010 20:13:51 +0400
Message-Id: <1279296831-24943-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() fails free allocated resources and exit.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/hv/channel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index f047c5a..78d1aa5 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -465,6 +465,8 @@ static int VmbusChannelCreateGpadlHeader(void *Kbuffer, u32 Size,
 			  sizeof(struct vmbus_channel_gpadl_header) +
 			  sizeof(struct gpa_range) + pageCount * sizeof(u64);
 		msgHeader = kzalloc(msgSize, GFP_KERNEL);
+		if (msgHeader == NULL)
+			goto nomem;
 		msgHeader->MessageSize = msgSize;
 
 		gpaHeader = (struct vmbus_channel_gpadl_header *)msgHeader->Msg;
-- 
1.7.0.4

