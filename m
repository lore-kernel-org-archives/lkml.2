Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879Ab2BJXJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:09:40 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab2BJWnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:00 -0500
MIME-Version: 1.0
Message-Id: <20120210222951.348984485@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [patch 71/86] target: Return correct ASC for unimplemented VPD pages
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit bb1acb2ee038a6c13ee99e0b9fb44dacb4a9de84 upstream.

My draft of SPC-4 says:

    If the device server does not implement the requested vital product
    data page, then the command shall be terminated with CHECK CONDITION
    status, with the sense key set to ILLEGAL REQUEST, and the
    additional sense code set to INVALID FIELD IN CDB.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_cdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -732,7 +732,7 @@ int target_emulate_inquiry(struct se_tas
 	}
 
 	pr_err("Unknown VPD Code: 0x%02x\n", cdb[2]);
-	cmd->scsi_sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
+	cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
 	ret = -EINVAL;
 
 out_unmap:


