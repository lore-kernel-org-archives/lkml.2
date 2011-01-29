Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1A2AwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:52:04 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26470 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1A2AwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:52:02 -0500
Date: Sat, 29 Jan 2011 01:53:09 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: [PATCH] SCSI, SAS, MPT: memset all of struct sas_identify, not just
 size of a pointer bytes
Message-ID: <alpine.LNX.2.00.1101290147120.6465@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a hard time believing that the intention of this code in 
drivers/scsi/mpt2sas/mpt2sas_transport.c
    static int
    _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
        struct sas_identify *identify)
    {
    ...
    	memset(identify, 0, sizeof(identify));
    ...
really is to just memset() the first few bytes (size of the pointer) of 
the struct.

I believe what is intended is to memset() the entire struct.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mpt2sas_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

  compile tested only

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index cb1cdec..9e86708 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -163,7 +163,7 @@ _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 		return -EIO;
 	}
 
-	memset(identify, 0, sizeof(identify));
+	memset(identify, 0, sizeof(*identify));
 	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
 
 	/* sas_address */


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

