Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1AAQYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 11:24:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49749 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1AAQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 11:24:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=OO6ULM+msGbEb6Ly5CXzRYYQvNKjbqCeReFhW1engcKUuUf6kGRNwq641dDV1Lstec
         7nCUHYlJiT1N4/Iy/18YxNvUxB+39zy9WDBBmQ8JuC8ctj2Jp+BDjE+5/YH6tbHb0YyI
         BKt1iaoA5ragJxxohSrErr/CFtrfXa6l0wgeM=
Message-ID: <4D1F5534.9080100@gmail.com>
Date: Sat, 01 Jan 2011 17:24:20 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, segooon@gmail.com
Subject: [PATCH] staging: spectra: don't read past array in Conv_Spare_Data_Log2Phy_Format()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should decrement or we read past the array

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/spectra/lld_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/spectra/lld_nand.c b/drivers/staging/spectra/lld_nand.c
index 0d647a8..79d00e8 100644
--- a/drivers/staging/spectra/lld_nand.c
+++ b/drivers/staging/spectra/lld_nand.c
@@ -1400,7 +1400,7 @@ void Conv_Spare_Data_Log2Phy_Format(u8 *data)
 	const u32 PageSpareSize  = DeviceInfo.wPageSpareSize;
 
 	if (enable_ecc) {
-		for (i = spareFlagBytes - 1; i >= 0; i++)
+		for (i = spareFlagBytes - 1; i >= 0; i--)
 			data[PageSpareSize - spareFlagBytes + i] = data[i];
 	}
 }
