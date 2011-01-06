Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1AFAbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:09 -0500
Received: from kroah.org ([198.145.64.141]:35974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab1AFAbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:07 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:07 2011
Message-Id: <20110106002307.369687728@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ken Mills <ken.k.mills@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: [112/152] n_gsm: gsm_data_alloc buffer allocation could fail and it is not being checked
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ken Mills <ken.k.mills@intel.com>

commit 093d804611b9a38fe59753b37c29f840518406a9 upstream.

gsm_data_alloc buffer allocation could fail and it is not being checked.

Add check for allocated buffer and return if the buffer allocation
fails.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/n_gsm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/n_gsm.c
+++ b/drivers/char/n_gsm.c
@@ -968,6 +968,8 @@ static void gsm_control_reply(struct gsm
 {
 	struct gsm_msg *msg;
 	msg = gsm_data_alloc(gsm, 0, dlen + 2, gsm->ftype);
+	if (msg == NULL)
+		return;
 	msg->data[0] = (cmd & 0xFE) << 1 | EA;	/* Clear C/R */
 	msg->data[1] = (dlen << 1) | EA;
 	memcpy(msg->data + 2, data, dlen);


