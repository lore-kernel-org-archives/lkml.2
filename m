Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab0LUE6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:58:49 -0500
Received: from kroah.org ([198.145.64.141]:59864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933609Ab0LUE6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:58:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ken Mills <ken.k.mills@intel.com>, Alan Cox <alan@linux.intel.com>,
        stable@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] n_gsm: gsm_data_alloc buffer allocation could fail and it is not being checked
Date: Mon, 20 Dec 2010 20:58:37 -0800
Message-Id: <1292907517-12275-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101221044205.GB11750@kroah.com>
References: <20101221044205.GB11750@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Mills <ken.k.mills@intel.com>

gsm_data_alloc buffer allocation could fail and it is not being checked.

Add check for allocated buffer and return if the buffer allocation
fails.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/n_gsm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 2fc5cf2..c5f8e5b 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -968,6 +968,8 @@ static void gsm_control_reply(struct gsm_mux *gsm, int cmd, u8 *data,
 {
 	struct gsm_msg *msg;
 	msg = gsm_data_alloc(gsm, 0, dlen + 2, gsm->ftype);
+	if (msg == NULL)
+		return;
 	msg->data[0] = (cmd & 0xFE) << 1 | EA;	/* Clear C/R */
 	msg->data[1] = (dlen << 1) | EA;
 	memcpy(msg->data + 2, data, dlen);
-- 
1.7.3.2

