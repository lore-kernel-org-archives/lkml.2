Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab0IHF6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 01:58:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46387 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab0IHF6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 01:58:47 -0400
Date: Wed, 8 Sep 2010 07:58:45 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (em, bedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 7/8] drivers/i2c/busses/i2c-amd8111.c: Fix unsigned return
 type
Message-ID: <Pine.LNX.4.64.1009080757050.27892@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, the function has an unsigned return type, but returns a
negative constant to indicate an error condition.  The result of calling
the function is always stored in a variable of type (signed) int, and thus
unsigned can be dropped from the return type.

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
 drivers/i2c/busses/i2c-amd8111.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-amd8111.c b/drivers/i2c/busses/i2c-amd8111.c
index af1e5e2..02a3726 100644
--- a/drivers/i2c/busses/i2c-amd8111.c
+++ b/drivers/i2c/busses/i2c-amd8111.c
@@ -69,7 +69,7 @@ static struct pci_driver amd8111_driver;
  * ACPI 2.0 chapter 13 access of registers of the EC
  */
 
-static unsigned int amd_ec_wait_write(struct amd_smbus *smbus)
+static int amd_ec_wait_write(struct amd_smbus *smbus)
 {
 	int timeout = 500;
 
@@ -85,7 +85,7 @@ static unsigned int amd_ec_wait_write(struct amd_smbus *smbus)
 	return 0;
 }
 
-static unsigned int amd_ec_wait_read(struct amd_smbus *smbus)
+static int amd_ec_wait_read(struct amd_smbus *smbus)
 {
 	int timeout = 500;
 

