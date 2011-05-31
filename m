Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab1EaTEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:04:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52387 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1EaTEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CmfOQRrG+CM/Jn180zV4HPS/5BTkjAeof9OXmB0XOlw+s0qGdO/sECQKEbf/pZ+JGP
         hfcttSlH8LTxqE5ENq0bLHZW8VN65h0EP1RD8bfPzHvaJt0t4IiUUQis1DfWsjRu1jR2
         YMr29edvt7U3auas6BY4P71QQlg/isgiHUufw=
From: Andre Bartke <andre.bartke@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] staging: intel_sst: Fix memory leak
Date: Tue, 31 May 2011 21:03:56 +0200
Message-Id: <1306868636-23367-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of an error stream_bufs is not freed here.

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 .../staging/intel_sst/intel_sst_app_interface.c    |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index b8c7ddb..93b41a2 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -430,8 +430,10 @@ static int snd_sst_fill_kernel_list(struct stream_info *stream,
 				return -ENOMEM;
 			if (copy_from_user((void *) &rar_handle,
 					iovec[index].iov_base,
-					sizeof(__u32)))
+					sizeof(__u32))) {
+				kfree(stream_bufs);
 				return -EFAULT;
+			}
 			stream_bufs->addr = (char *)rar_handle;
 			stream_bufs->in_use = false;
 			stream_bufs->size = iovec[0].iov_len;
-- 
1.7.5.2

