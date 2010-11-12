Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab0KLVl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:41:29 -0500
Received: from kroah.org ([198.145.64.141]:41629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933093Ab0KLVlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ken Mills <ken.k.mills@intel.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/19] n_gsm: Fix length handling
Date: Fri, 12 Nov 2010 13:41:06 -0800
Message-Id: <1289598066-10112-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Mills <ken.k.mills@intel.com>

If the mux is configured with a large mru/mtu the existing code gets the
byte ordering wrong for the header.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/n_gsm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 7f79044..81b4658 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -716,8 +716,8 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 		if (msg->len < 128)
 			*--dp = (msg->len << 1) | EA;
 		else {
-			*--dp = (msg->len >> 6) | EA;
-			*--dp = (msg->len & 127) << 1;
+			*--dp = ((msg->len & 127) << 1) | EA;
+			*--dp = (msg->len >> 6) & 0xfe;
 		}
 	}
 
-- 
1.7.1

