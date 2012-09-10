Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2IJEtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:49:25 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40759 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2IJEtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:49:24 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 12:49:23 +0800
Message-ID: <CAPgLHd81OwYR65x56Fe1+hcWQsK1wiA6+MQYLBwvP59o-kH8QA@mail.gmail.com>
Subject: [PATCH] ARM: davinci: dm644x: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: nsekhar@ti.com, khilman@ti.com, linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-davinci/board-dm644x-evm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index d34ed55..b54dc03 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -518,13 +518,11 @@ static int dm6444evm_msp430_get_pins(void)
 	char buf[4];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = dm6446evm_msp->addr,
 			.flags = 0,
 			.len = 2,
 			.buf = (void __force *)txbuf,
 		},
 		{
-			.addr = dm6446evm_msp->addr,
 			.flags = I2C_M_RD,
 			.len = 4,
 			.buf = buf,
@@ -535,6 +533,9 @@ static int dm6444evm_msp430_get_pins(void)
 	if (!dm6446evm_msp)
 		return -ENXIO;
 
+	msg[0].addr = dm6446evm_msp->addr;
+	msg[1].addr = dm6446evm_msp->addr;
+
 	/* Command 4 == get input state, returns port 2 and port3 data
 	 *   S Addr W [A] len=2 [A] cmd=4 [A]
 	 *   RS Addr R [A] [len=4] A [cmd=4] A [port2] A [port3] N P

