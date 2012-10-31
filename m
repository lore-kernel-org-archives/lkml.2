Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188Ab2JaWsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:48:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36993 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760983Ab2JaWrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:47:03 -0400
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjur@brendeland.net, dmitry.tarnyagin@stericsson.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC virtio-next 2/4] include/vring.h: Add support for reversed vritio rings.
Date: Wed, 31 Oct 2012 23:46:52 +0100
Message-Id: <1351723614-4145-3-git-send-email-sjur@brendeland.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
References: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add last avilable index to the vring_virtqueue structure,
this is done to prepare for implementation of the reversed vring.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/virtio/vring.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/vring.h b/drivers/virtio/vring.h
index b997fc3..3b53961 100644
--- a/drivers/virtio/vring.h
+++ b/drivers/virtio/vring.h
@@ -51,6 +51,9 @@ struct vring_virtqueue
 	/* Last used index we've seen. */
 	u16 last_used_idx;
 
+	/* Last avail index seen. NOTE: Only used for reversed rings.*/
+	u16 last_avail_idx;
+
 	/* How to notify other side. FIXME: commonalize hcalls! */
 	void (*notify)(struct virtqueue *vq);
 
-- 
1.7.9.5

