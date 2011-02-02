Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1BBAvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:51:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:28733 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab1BBApE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505273"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: ken.k.mills@intel.com, alan@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [105/139] n_gsm: gsm_data_alloc buffer allocation could fail and it is not being checked
Message-Id: <20110202004503.9DF7A3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ken Mills <ken.k.mills@intel.com>

commit 093d804611b9a38fe59753b37c29f840518406a9 upstream.

gsm_data_alloc buffer allocation could fail and it is not being checked.

Add check for allocated buffer and return if the buffer allocation
fails.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/n_gsm.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/char/n_gsm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/n_gsm.c
+++ linux-2.6.35.y/drivers/char/n_gsm.c
@@ -969,6 +969,8 @@ static void gsm_control_reply(struct gsm
 {
 	struct gsm_msg *msg;
 	msg = gsm_data_alloc(gsm, 0, dlen + 2, gsm->ftype);
+	if (msg == NULL)
+		return;
 	msg->data[0] = (cmd & 0xFE) << 1 | EA;	/* Clear C/R */
 	msg->data[1] = (dlen << 1) | EA;
 	memcpy(msg->data + 2, data, dlen);
