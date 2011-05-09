Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1EIGLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:11:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1367 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab1EIGLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:11:47 -0400
Subject: [PATCH] mpt2sas: Fix memset using sizeof(ptr) not sizeof(*ptr)
From: Joe Perches <joe@perches.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 23:11:45 -0700
Message-ID: <1304921505.19586.26.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found via coccinelle script

@@
type T;
T* ptr;
expression E1;
@@

* memset(E1, 0, sizeof(ptr));

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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


