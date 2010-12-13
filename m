Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab0LMPt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:49:29 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53847 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab0LMPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:49:28 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] n_gsm: gsm_data_alloc buffer allocation could fail and it
 is not being checked
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 13 Dec 2010 15:28:03 +0000
Message-ID: <20101213152738.19871.9615.stgit@bob.linux.org.uk>
In-Reply-To: <20101213152658.19871.37910.stgit@bob.linux.org.uk>
References: <20101213152658.19871.37910.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
---

 drivers/tty/n_gsm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 6652024..aa2e5d3 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -978,6 +978,8 @@ static void gsm_control_reply(struct gsm_mux *gsm, int cmd, u8 *data,
 {
 	struct gsm_msg *msg;
 	msg = gsm_data_alloc(gsm, 0, dlen + 2, gsm->ftype);
+	if (msg == NULL)
+		return;
 	msg->data[0] = (cmd & 0xFE) << 1 | EA;	/* Clear C/R */
 	msg->data[1] = (dlen << 1) | EA;
 	memcpy(msg->data + 2, data, dlen);

