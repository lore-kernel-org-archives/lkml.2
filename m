Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0IETAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 15:00:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35479 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab0IES7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:59:37 -0400
From: Julia Lawall <julia@diku.dk>
To: Olof Johansson <olof@lixom.net>
Cc: kernel-janitors@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] drivers/i2c/busses/i2c-pasemi.c: Fix unsigned return type
Date: Sun,  5 Sep 2010 21:00:22 +0200
Message-Id: <1283713226-8429-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283713226-8429-1-git-send-email-julia@diku.dk>
References: <1283713226-8429-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function has an unsigned return type, but returns a negative constant
to indicate an error condition.  The result of calling the function is
always stored in a variable of type (signed) int, and thus unsigned can be
dropped from the return type.

A sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
identifier f;
constant C;
@@

 unsigned f(...)
 { <+...
*  return -C;
 ...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/i2c/busses/i2c-pasemi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-pasemi.c b/drivers/i2c/busses/i2c-pasemi.c
index 4174101..837b8c1 100644
--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -88,7 +88,7 @@ static void pasemi_smb_clear(struct pasemi_smbus *smbus)
 	reg_write(smbus, REG_SMSTA, status);
 }
 
-static unsigned int pasemi_smb_waitready(struct pasemi_smbus *smbus)
+static int pasemi_smb_waitready(struct pasemi_smbus *smbus)
 {
 	int timeout = 10;
 	unsigned int status;

