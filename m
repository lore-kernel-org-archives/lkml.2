Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab2K0Rdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:33:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45984 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2K0Rdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:33:41 -0500
Date: Tue, 27 Nov 2012 20:33:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Naresh Kumar Inna <naresh@chelsio.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] csiostor: remove unneeded memset()
Message-ID: <20121127173330.GD1059@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to memset() this when we just copy over it on the next line.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index 551959e..8b54976 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -245,7 +245,6 @@ csio_append_attrib(uint8_t **ptr, uint16_t type, uint8_t *val, uint16_t len)
 	len += 4;		/* includes attribute type and length */
 	len = (len + 3) & ~3;	/* should be multiple of 4 bytes */
 	ae->len = htons(len);
-	memset(ae->value, 0, len - 4);
 	memcpy(ae->value, val, len);
 	*ptr += len;
 }
