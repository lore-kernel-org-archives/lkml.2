Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0ERFaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:30:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53906 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab0ERFaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gR9EByFze0eziPZeIs84CHEOk6KmLVM2nQBCAbDXLs3xfnYbGqfR6rMJSWs3d6yxdk
         F+WlZpdxPPe7I2wSMG+X/txCmDPm9fzXSAbvQvlQITlDgJVCi/pvXvESD9uiSnlqaDv0
         hIG5S6RO1qtjr04oQLbdZLZdjcpOCx79uRdd0=
MIME-Version: 1.0
Date: Tue, 18 May 2010 13:30:16 +0800
Message-ID: <AANLkTinX8Ax9ZJFdLk3Zjzc0CBh-gIIN0wg8YjQ-7PQP@mail.gmail.com>
Subject: [PATCH] drbd: Check-kmalloc-return-value before use it
From: Steven Liu <lingjiujianke@gmail.com>
To: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
       linux-kernel@vger.kernel.org, liuqi@thunderst.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check-kmalloc-return-value before use it

Signed-off-by: Liu Qi <lingjiujianke@gmail.com>
---
 drivers/block/drbd/drbd_receiver.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c
b/drivers/block/drbd/drbd_receiver.c
index 3f096e7..533df04 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2977,6 +2977,10 @@ static int receive_uuids(struct drbd_conf
*mdev, struct p_header *h)
        return FALSE;

    p_uuid = kmalloc(sizeof(u64)*UI_EXTENDED_SIZE, GFP_NOIO);
+   if(p_uuid == NULL){
+       printk(KERN_ERR "Kmalloc p_uuid failed in %s \n", __func__);
+       return FALSE;
+   }

    for (i = UI_CURRENT; i < UI_EXTENDED_SIZE; i++)
        p_uuid[i] = be64_to_cpu(p->uuid[i]);
--
1.7.1


Best regards
