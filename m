Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3AHXhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:34 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53627 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3AHXhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:22 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>, Sekhar Nori <nsekhar@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 45/77] ARM: davinci: dm646x evm: wrong register used in setup_vpif_input_channel_mode
Date: Tue, 8 Jan 2013 18:35:24 -0500
Message-ID: <1357688156-25387-46-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 83713fc9373be2e943f82e9d36213708c6b0050e upstream.

The function setup_vpif_input_channel_mode() used the VSCLKDIS register
instead of VIDCLKCTL. This meant that when in HD mode videoport channel 0
used a different clock from channel 1.

Clearly a copy-and-paste error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/mach-davinci/board-dm646x-evm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 5ba3cb2..ff0fd90 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -555,7 +555,7 @@ static int setup_vpif_input_channel_mode(int mux_mode)
 	int val;
 	u32 value;
 
-	if (!vpif_vsclkdis_reg || !cpld_client)
+	if (!vpif_vidclkctl_reg || !cpld_client)
 		return -ENXIO;
 
 	val = i2c_smbus_read_byte(cpld_client);
@@ -563,7 +563,7 @@ static int setup_vpif_input_channel_mode(int mux_mode)
 		return val;
 
 	spin_lock_irqsave(&vpif_reg_lock, flags);
-	value = __raw_readl(vpif_vsclkdis_reg);
+	value = __raw_readl(vpif_vidclkctl_reg);
 	if (mux_mode) {
 		val &= VPIF_INPUT_TWO_CHANNEL;
 		value |= VIDCH1CLK;
@@ -571,7 +571,7 @@ static int setup_vpif_input_channel_mode(int mux_mode)
 		val |= VPIF_INPUT_ONE_CHANNEL;
 		value &= ~VIDCH1CLK;
 	}
-	__raw_writel(value, vpif_vsclkdis_reg);
+	__raw_writel(value, vpif_vidclkctl_reg);
 	spin_unlock_irqrestore(&vpif_reg_lock, flags);
 
 	err = i2c_smbus_write_byte(cpld_client, val);
-- 
1.7.12.1

