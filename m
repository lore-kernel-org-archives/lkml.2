Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0JCNKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 09:10:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51913 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0JCNKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 09:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ImRvylN75EhxNFr/03WxmaI+Vc6fiQhWH9BPqaZFu8DKbBUhibVS1XMdWPUGgQmqMo
         GnW3lELrNA//iXGkiekA8f5N0HFRjjOXdYKAAmeb4dsXf4IvH9mPAzOODILaHeVH6ChQ
         3SaKD/8Mtj/HHBFUvMg21A+VGWm4S0eLvvVyM=
MIME-Version: 1.0
Date: Sun, 3 Oct 2010 21:10:03 +0800
Message-ID: <AANLkTi=SD8VTS_nYjeCG3m06S9ZcSOdSjL78aMKUT3zH@mail.gmail.com>
Subject: Ask For Comment: add new API related to sg_miter_start in scatter list
From: Hillf Danton <dhillf@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, robert.w.love@intel.com,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like sg_miter_start, the new API also init the __offset element of miter
with given parameter.
Then the precesure of sg_miter_start, sg_miter_next and sg_miter_stop
could be carried out as smoothly as sg_copy_buffer does,  with
all __xyz elements of miter untouched outside miter.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- o/linux-2.6.36-rc4/include/linux/scatterlist.h	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/include/linux/scatterlist.h	2010-10-03
20:45:12.000000000 +0800
@@ -264,4 +264,18 @@ void sg_miter_start(struct sg_mapping_it
 bool sg_miter_next(struct sg_mapping_iter *miter);
 void sg_miter_stop(struct sg_mapping_iter *miter);

+/*
+ * like sg_miter_start, plus setting the offset in sg
+ */
+static void
+sg_miter_start_offset(struct sg_mapping_iter *miter,
+			struct scatterlist *sgl,
+			unsigned int nents,
+			unsigned int flags,
+			unsigned int offset)
+{
+	sg_miter_start(miter, sgl, nents, flags);
+	miter->__offset = offset;
+}
+
 #endif /* _LINUX_SCATTERLIST_H */
