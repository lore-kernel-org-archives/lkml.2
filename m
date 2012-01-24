Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab2AXCvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:51:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932925Ab2AXCtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:49:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:33 2012
Message-Id: <20120124023933.368836771@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [106/129] target: Set response format in INQUIRY response
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1233
Lines: 38

From: Roland Dreier <roland@purestorage.com>

commit ce136176fea522fc8f4c16dcae7e8ed1d890ca39 upstream.

Current SCSI specs say that the "response format" field in the standard
INQUIRY response should be set to 2, and all the real SCSI devices I
have do put 2 here.  So let's do that too.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_cdb.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -94,6 +94,18 @@ target_emulate_inquiry_std(struct se_cmd
 	buf[2] = dev->transport->get_device_rev(dev);
 
 	/*
+	 * NORMACA and HISUP = 0, RESPONSE DATA FORMAT = 2
+	 *
+	 * SPC4 says:
+	 *   A RESPONSE DATA FORMAT field set to 2h indicates that the
+	 *   standard INQUIRY data is in the format defined in this
+	 *   standard. Response data format values less than 2h are
+	 *   obsolete. Response data format values greater than 2h are
+	 *   reserved.
+	 */
+	buf[3] = 2;
+
+	/*
 	 * Enable SCCS and TPGS fields for Emulated ALUA
 	 */
 	if (dev->se_sub_dev->t10_alua.alua_type == SPC3_ALUA_EMULATED)


