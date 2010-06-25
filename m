Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0FYReN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 13:34:13 -0400
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:47737 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab0FYReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 13:34:12 -0400
X-MXL-Hash: 4c24e8943f68e422-c92e4fff9a944c47d91631aa30deed37839da585
X-MXL-Hash: 4c24e88944d1d9b8-423acd2b5676a407e6afa44e344644e709444055
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155: remove unused 32-bit and 8-bit global registers
Date: Fri, 25 Jun 2010 10:33:34 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201006251033.35126.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010062201)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.31]
X-AnalysisOut: [v=1.0 c=1 a=ub1V67TprLUA:10 a=1CvaPgNKC-EA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=qS3xps/WtSuafY8lc/WARg==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=fdcXP4HReajemwIiH-8A:9 a=XZajzOm1oMqSi76haS]
X-AnalysisOut: [dZlalJZu4A:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=0kPLrQd]
X-AnalysisOut: [w3YYA:10 a=ZeOH7y6vJHX-hPBB:21 a=ieQWaMhnnZlIAnyP:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the board 32-bit registers and 8-bit i2c registers are either read before
writing to them or they are just written to with a new value.  There is no reason
to keep a 'local' copy of any of them.

As a first step to removing them, get rid of all the ones that are not used in
the driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_io.c b/drivers/staging/dt3155/dt3155_io.c
index 485cc5e..b2f2f1e 100644
--- a/drivers/staging/dt3155/dt3155_io.c
+++ b/drivers/staging/dt3155/dt3155_io.c
@@ -33,25 +33,12 @@ u32 even_dma_start_r;	/*  bit 0 should always be 0 */
 u32 odd_dma_start_r;	/*               .. */
 u32 even_dma_stride_r;	/*  bits 0&1 should always be 0 */
 u32 odd_dma_stride_r;	/*               .. */
-u32 even_pixel_fmt_r;
-u32 odd_pixel_fmt_r;
 
-FIFO_TRIGGER_R		fifo_trigger_r;
-XFER_MODE_R		xfer_mode_r;
 CSR1_R			csr1_r;
-RETRY_WAIT_CNT_R	retry_wait_cnt_r;
 INT_CSR_R		int_csr_r;
 
-u32 even_fld_mask_r;
-u32 odd_fld_mask_r;
-
-MASK_LENGTH_R		mask_length_r;
-FIFO_FLAG_CNT_R		fifo_flag_cnt_r;
-IIC_CLK_DUR_R		iic_clk_dur_r;
 IIC_CSR1_R		iic_csr1_r;
 IIC_CSR2_R		iic_csr2_r;
-DMA_UPPER_LMT_R		even_dma_upper_lmt_r;
-DMA_UPPER_LMT_R		odd_dma_upper_lmt_r;
 
 
 
@@ -59,18 +46,6 @@ DMA_UPPER_LMT_R		odd_dma_upper_lmt_r;
 I2C_CSR2 i2c_csr2;
 I2C_EVEN_CSR i2c_even_csr;
 I2C_ODD_CSR i2c_odd_csr;
-I2C_CONFIG i2c_config;
-u8 i2c_dt_id;
-u8 i2c_x_clip_start;
-u8 i2c_y_clip_start;
-u8 i2c_x_clip_end;
-u8 i2c_y_clip_end;
-u8 i2c_ad_addr;
-u8 i2c_ad_lut;
-I2C_AD_CMD i2c_ad_cmd;
-u8 i2c_dig_out;
-u8 i2c_pm_lut_addr;
-u8 i2c_pm_lut_data;
 
 /*
  * wait_ibsyclr()
diff --git a/drivers/staging/dt3155/dt3155_io.h b/drivers/staging/dt3155/dt3155_io.h
index a9aa754..730e30a 100644
--- a/drivers/staging/dt3155/dt3155_io.h
+++ b/drivers/staging/dt3155/dt3155_io.h
@@ -213,25 +213,12 @@ extern u32 even_dma_start_r;		/*  bit 0 should always be 0 */
 extern u32 odd_dma_start_r;		/*               ..          */
 extern u32 even_dma_stride_r;	/*  bits 0&1 should always be 0 */
 extern u32 odd_dma_stride_r;		/*               ..             */
-extern u32 even_pixel_fmt_r;
-extern u32 odd_pixel_fmt_r;
 
-extern FIFO_TRIGGER_R		fifo_trigger_r;
-extern XFER_MODE_R		xfer_mode_r;
 extern CSR1_R			csr1_r;
-extern RETRY_WAIT_CNT_R		retry_wait_cnt_r;
 extern INT_CSR_R		int_csr_r;
 
-extern u32 even_fld_mask_r;
-extern u32 odd_fld_mask_r;
-
-extern MASK_LENGTH_R		mask_length_r;
-extern FIFO_FLAG_CNT_R		fifo_flag_cnt_r;
-extern IIC_CLK_DUR_R		iic_clk_dur_r;
 extern IIC_CSR1_R		iic_csr1_r;
 extern IIC_CSR2_R		iic_csr2_r;
-extern DMA_UPPER_LMT_R		even_dma_upper_lmt_r;
-extern DMA_UPPER_LMT_R		odd_dma_upper_lmt_r;
 
 
 
@@ -330,18 +317,6 @@ typedef union i2c_ad_cmd_tag {
 extern I2C_CSR2			i2c_csr2;
 extern I2C_EVEN_CSR		i2c_even_csr;
 extern I2C_ODD_CSR		i2c_odd_csr;
-extern I2C_CONFIG		i2c_config;
-extern u8			i2c_dt_id;
-extern u8			i2c_x_clip_start;
-extern u8			i2c_y_clip_start;
-extern u8			i2c_x_clip_end;
-extern u8			i2c_y_clip_end;
-extern u8			i2c_ad_addr;
-extern u8			i2c_ad_lut;
-extern I2C_AD_CMD		i2c_ad_cmd;
-extern u8			i2c_dig_out;
-extern u8			i2c_pm_lut_addr;
-extern u8			i2c_pm_lut_data;
 
 /* Functions for Global use */
 
