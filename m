Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0IJLUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:20:21 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:44877 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab0IJLUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:20:20 -0400
Subject: [PATCH] libata: reorder ata_queued_cmd to remove alignment padding
 on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: jgarzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 12:19:43 +0100
Message-ID: <1284117583.1903.8.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder structure ata_queued_cmd to remove 8 bytes of alignment padding
on 64 bit builds & therefore reduce the size of structure ata_port by
256 bytes.
    
Overall this will have little impact, other than reducing the amount of
memory that is cleared when allocating ata_ports.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----
patch against 2.6.36-rc3
compiled & tested on x86_64

I've been running this patch for a couple of weeks with no apparent
issues.

regards
Richard



diff --git a/include/linux/libata.h b/include/linux/libata.h
index f010f18..e115380 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -559,13 +559,13 @@ struct ata_queued_cmd {
 	unsigned int		extrabytes;
 	unsigned int		curbytes;
 
-	struct scatterlist	*cursg;
-	unsigned int		cursg_ofs;
-
 	struct scatterlist	sgent;
 
 	struct scatterlist	*sg;
 
+	struct scatterlist	*cursg;
+	unsigned int		cursg_ofs;
+
 	unsigned int		err_mask;
 	struct ata_taskfile	result_tf;
 	ata_qc_cb_t		complete_fn;


