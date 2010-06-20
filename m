Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0FTR6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 13:58:54 -0400
Received: from imr3.ericy.com ([198.24.6.13]:44858 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab0FTR6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 13:58:52 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: khali@linux-fr.org, ben-linux@fluff.org, hsweeten@visionengravers.com
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] i2c/mips: Fix error return codes from Sibyte i2c bus driver
Date: Sun, 20 Jun 2010 10:57:53 -0700
Message-ID: <1277056673-4305-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sibyte i2c bus driver returns non-descriptive error values.
Update to return error values as defined in Documentation/i2c/fault-codes.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/i2c/busses/i2c-sibyte.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-sibyte.c b/drivers/i2c/busses/i2c-sibyte.c
index 3d76a18..329cbee 100644
--- a/drivers/i2c/busses/i2c-sibyte.c
+++ b/drivers/i2c/busses/i2c-sibyte.c
@@ -94,7 +94,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
 		}
 		break;
 	default:
-		return -1;      /* XXXKW better error code? */
+		return -EOPNOTSUPP;
 	}
 
 	while (csr_in32(SMB_CSR(adap, R_SMB_STATUS)) & M_SMB_BUSY)
@@ -104,7 +104,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
 	if (error & M_SMB_ERROR) {
 		/* Clear error bit by writing a 1 */
 		csr_out32(M_SMB_ERROR, SMB_CSR(adap, R_SMB_STATUS));
-		return -1;      /* XXXKW better error code? */
+		return -ENXIO;
 	}
 
 	if (data_bytes == 1)
-- 
1.7.0.87.g0901d

