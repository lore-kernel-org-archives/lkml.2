Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2IUGMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:12:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52396 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2IUGMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:12:32 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 14:12:31 +0800
Message-ID: <CAPgLHd-xYzLwnptYpOV4HrdJyn3AZahx2VGVAVLHiEYvcj-APw@mail.gmail.com>
Subject: [PATCH] davinci: fix return value check by using IS_ERR in tnetv107x_devices_init()
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

In case of error, the function clk_get() returns ERR_PTR() not
NULL pointer. The NULL test in the error handling should be
replaced with IS_ERR().

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-davinci/devices-tnetv107x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/devices-tnetv107x.c b/arch/arm/mach-davinci/devices-tnetv107x.c
index 29b17f7..773ab07 100644
--- a/arch/arm/mach-davinci/devices-tnetv107x.c
+++ b/arch/arm/mach-davinci/devices-tnetv107x.c
@@ -374,7 +374,7 @@ void __init tnetv107x_devices_init(struct tnetv107x_device_info *info)
 	 * complete sample conversion in time.
 	 */
 	tsc_clk = clk_get(NULL, "sys_tsc_clk");
-	if (tsc_clk) {
+	if (!IS_ERR(tsc_clk)) {
 		error = clk_set_rate(tsc_clk, 5000000);
 		WARN_ON(error < 0);
 		clk_put(tsc_clk);


