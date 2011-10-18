Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1JRG03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:26:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18821 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1JRG0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:26:25 -0400
Date: Tue, 18 Oct 2011 09:26:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] gpio-pch: add an __iomem anotation
Message-ID: <20111018062621.GN27732@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E9D1C10.00EA:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding an __iomem anotation here silences some Sparse warnings.

drivers/gpio/gpio-pch.c:246:24: warning: incorrect type in assignment (different address spaces)
drivers/gpio/gpio-pch.c:246:24:    expected unsigned int [usertype] *im_reg
drivers/gpio/gpio-pch.c:246:24:    got unsigned int [noderef] <asn:2>*<noident>
drivers/gpio/gpio-pch.c:249:24: warning: incorrect type in assignment (different address spaces)
drivers/gpio/gpio-pch.c:249:24:    expected unsigned int [usertype] *im_reg
drivers/gpio/gpio-pch.c:249:24:    got unsigned int [noderef] <asn:2>*<noident>
drivers/gpio/gpio-pch.c:282:23: warning: incorrect type in argument 1 (different address spaces)
drivers/gpio/gpio-pch.c:282:23:    expected void [noderef] <asn:2>*<noident>
drivers/gpio/gpio-pch.c:282:23:    got unsigned int [usertype] *im_reg
drivers/gpio/gpio-pch.c:283:47: warning: incorrect type in argument 2 (different address spaces)
drivers/gpio/gpio-pch.c:283:47:    expected void [noderef] <asn:2>*<noident>
drivers/gpio/gpio-pch.c:283:47:    got unsigned int [usertype] *im_reg

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 596e454..4068084 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -231,7 +231,7 @@ static void pch_gpio_setup(struct pch_gpio *chip)
 static int pch_irq_type(struct irq_data *d, unsigned int type)
 {
 	u32 im;
-	u32 *im_reg;
+	u32 __iomem *im_reg;
 	u32 ien;
 	u32 im_pos;
 	int ch;
