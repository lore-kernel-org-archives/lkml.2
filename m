Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab1DEVic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:38:32 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45695 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883Ab1DEViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JVhlAGfk9vs72WQO4EmYUo9Uv0YhTpNc9QiurP20DAsnPnQm57KxigeEf1dKihqf/3
         O6TAs48BaMS+Z75CqVDgWwKGcbm6cs8op0MdykC5LyayHw6lHSeBWQRhdf7r/gllVpCP
         NfK2KHXM5SsFxK72GYXfxW89dkM3+UeI86uQU=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: davinci-linux-open-source@linux.davincidsp.com, linux-i2c@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        Brad Griffis <bgriffis@ti.com>, Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>, Sekhar Nori <nsekhar@ti.com>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 5/6] i2c-davinci: if device has pfunc register, dump that group also
Date: Tue,  5 Apr 2011 17:38:08 -0400
Message-Id: <3a177f7c5f48db679db25035911abd2f53203122.1302031487.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1302031487.git.bengardiner@nanometrics.ca>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the platform has indicated that this I2c controller has the ICPFUNC
regsiters then also dump their contents when producing a debug register dump.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Bastian Ruppert <Bastian.Ruppert@sewerin.de>
Cc: Brad Griffis <bgriffis@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Ben Dooks <ben-linux@fluff.org>

---
 drivers/i2c/busses/i2c-davinci.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 5bdc98c..a084e50 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -164,6 +164,8 @@ static inline u16 davinci_i2c_read_reg(struct davinci_i2c_dev *i2c_dev, int reg)
 
 static void i2c_davinci_dump_regs(struct davinci_i2c_dev *dev)
 {
+	struct davinci_i2c_platform_data *pdata = dev->dev->platform_data;
+
 	dev_dbg(dev->dev, "PSC  = %08x\n",
 		davinci_i2c_read_reg(dev, DAVINCI_I2C_PSC_REG));
 	dev_dbg(dev->dev, "CLKL = %08x\n",
@@ -191,6 +193,19 @@ static void i2c_davinci_dump_regs(struct davinci_i2c_dev *dev)
 		davinci_i2c_read_reg(dev, DAVINCI_I2C_IVR_REG));
 	dev_dbg(dev->dev, "EMDR = %08x\n",
 		davinci_i2c_read_reg(dev, DAVINCI_I2C_EMDR_REG));
+
+	if (pdata->has_pfunc) {
+		dev_dbg(dev->dev, "PFUNC = %08x\n",
+			davinci_i2c_read_reg(dev, DAVINCI_I2C_PFUNC_REG));
+		dev_dbg(dev->dev, "PDIR = %08x\n",
+			davinci_i2c_read_reg(dev, DAVINCI_I2C_PDIR_REG));
+		dev_dbg(dev->dev, "PDIN = %08x\n",
+			davinci_i2c_read_reg(dev, DAVINCI_I2C_PDIN_REG));
+		dev_dbg(dev->dev, "DSET = %08x\n",
+			davinci_i2c_read_reg(dev, DAVINCI_I2C_DSET_REG));
+		dev_dbg(dev->dev, "DCLR = %08x\n",
+			davinci_i2c_read_reg(dev, DAVINCI_I2C_DCLR_REG));
+	}
 }
 
 /* Generate a pulse on the i2c clock pin. */
-- 
1.7.1

