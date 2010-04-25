Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0DYNn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:43:56 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:37511 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab0DYNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=a0OSakmKW89yde14Y86QXOmYrQPda+heshC3jXQEZHHbYeTvCWzKGGu3qunaXSa4fm
         ca9xUFerOJk+8HFNrn7UaDZQpY4zaNlnpqOh/cFs+3vc3BKLSZoyZLljVv9WTTLb+1gO
         QTasHegPqjeu/J95wuzMN+CzlLPFcHMLSsS6A=
Date: Sun, 25 Apr 2010 22:22:26 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] staging: crystalhd: remove unused BC_STATUS codes
Message-Id: <20100425222226.356b2a9d.yuasa@linux-mips.org>
In-Reply-To: <20100425221851.223dc284.yuasa@linux-mips.org>
References: <20100425221851.223dc284.yuasa@linux-mips.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 drivers/staging/crystalhd/bc_dts_defs.h   |   13 -------------
 drivers/staging/crystalhd/crystalhd_lnx.c |    2 --
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/crystalhd/bc_dts_defs.h b/drivers/staging/crystalhd/bc_dts_defs.h
index e825312..d7e6a9e 100644
--- a/drivers/staging/crystalhd/bc_dts_defs.h
+++ b/drivers/staging/crystalhd/bc_dts_defs.h
@@ -34,28 +34,15 @@ typedef enum _BC_STATUS {
 	BC_STS_INV_ARG		= 1,
 	BC_STS_BUSY		= 2,
 	BC_STS_NOT_IMPL		= 3,
-	BC_STS_PGM_QUIT		= 4,
-	BC_STS_NO_ACCESS	= 5,
 	BC_STS_INSUFF_RES	= 6,
 	BC_STS_IO_ERROR		= 7,
 	BC_STS_NO_DATA		= 8,
-	BC_STS_VER_MISMATCH	= 9,
 	BC_STS_TIMEOUT		= 10,
 	BC_STS_FW_CMD_ERR	= 11,
-	BC_STS_DEC_NOT_OPEN	= 12,
 	BC_STS_ERR_USAGE	= 13,
 	BC_STS_IO_USER_ABORT	= 14,
-	BC_STS_IO_XFR_ERROR	= 15,
-	BC_STS_DEC_NOT_STARTED	= 16,
-	BC_STS_FWHEX_NOT_FOUND	= 17,
-	BC_STS_FMT_CHANGE	= 18,
-	BC_STS_HIF_ACCESS	= 19,
 	BC_STS_CMD_CANCELLED	= 20,
 	BC_STS_FW_AUTH_FAILED	= 21,
-	BC_STS_BOOTLOADER_FAILED = 22,
-	BC_STS_CERT_VERIFY_ERROR = 23,
-	BC_STS_DEC_EXIST_OPEN	= 24,
-	BC_STS_PENDING		= 25,
 	BC_STS_CLK_NOCHG	= 26,
 
 	/* Must be the last one.*/
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 3eac70a..6ef54e3 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -245,8 +245,6 @@ static int chd_dec_api_cmd(struct crystalhd_adp *adp, unsigned long ua,
 	rc = chd_dec_proc_user_data(adp, temp, ua, 0);
 	if (!rc) {
 		sts = func(&adp->cmds, temp);
-		if (sts == BC_STS_PENDING)
-			sts = BC_STS_NOT_IMPL;
 		temp->udata.RetSts = sts;
 		rc = chd_dec_proc_user_data(adp, temp, ua, 1);
 	}
-- 
1.7.1

