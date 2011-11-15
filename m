Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab1KOMbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:31:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40785 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1KOMbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:31:49 -0500
Message-ID: <4EC25B91.9050806@gmail.com>
Date: Tue, 15 Nov 2011 20:31:13 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM: NUC900: add clock source select for ac97 and i2s
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add clock source select for ac97 and i2s,
since I will implement the i2s driver, so this "nuc900-audio" is not
yet specific for AC97.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/clksel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-w90x900/clksel.c b/arch/arm/mach-w90x900/clksel.c
index 3de4a52..76ccabe 100644
--- a/arch/arm/mach-w90x900/clksel.c
+++ b/arch/arm/mach-w90x900/clksel.c
@@ -48,7 +48,8 @@ static void clock_source_select(const char *dev_id,
unsigned int clkval)
 		offset = ATAOFFSET;
 	else if (strcmp(dev_id, "nuc900-lcd") == 0)
 		offset = LCDOFFSET;
-	else if (strcmp(dev_id, "nuc900-audio") == 0)
+	else if (strcmp(dev_id, "nuc900-audio-ac97") == 0 ||
+				strcmp(dev_id, "nuc900-audio-i2s") == 0)
 		offset = AUDOFFSET;
 	else
 		offset = CPUOFFSET;
-- 
1.7.0.4
