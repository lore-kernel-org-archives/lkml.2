Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2EOLEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:04:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab2EOLEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:04:50 -0400
From: Hannes Reinecke <hare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] EDD: Check for correct EDD 3.0 length
Date: Tue, 15 May 2012 13:04:49 +0200
Message-Id: <1337079889-62380-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device_path_info_length for EDD 3.0 is 36, not 44.
Cf http://mbldr.sourceforge.net/specsedd30.pdf.

This is a regression introduced by commit
0c61227094b3ddaca2f847ee287c4a2e3762b5a2

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index e229576..09a77d5 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -545,8 +545,8 @@ edd_has_edd30(struct edd_device *edev)
 	}
 
 
-	/* We support only T13 spec */
-	if (info->params.device_path_info_length != 44)
+	/* EDD 3.0 specifies this to be 36 */
+	if (info->params.device_path_info_length != 36)
 		return 0;
 
 	for (i = 30; i < info->params.device_path_info_length + 30; i++)
