Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1DHF0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 01:26:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56237 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1DHF0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 01:26:36 -0400
Date: Fri, 8 Apr 2011 15:26:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ameya Palande <ameya.palande@nokia.com>
Subject: linux-next: manual merge of the drivers-x86 tree with Linus' tree
Message-Id: <20110408152630.0aca7b6f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Today's linux-next merge of the drivers-x86 tree got a conflict in
drivers/platform/x86/intel_mid_thermal.c between commit 25985edcedea
("Fix common misspellings") from Linus' tree and commit 55488261b326
("platform-x86: intel_mid_thermal: Fix coding style") from the
drivers-x86 tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/intel_mid_thermal.c
index c2f4bd8,9ee707f..0000000
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@@ -178,47 -179,47 +179,47 @@@ static int adc_to_temp(int direct, uint
   */
  static int mid_read_temp(struct thermal_zone_device *tzd, unsigned long *temp)
  {
-        struct thermal_device_info *td_info = tzd->devdata;
-        uint16_t adc_val, addr;
-        uint8_t data = 0;
-        int ret;
-        unsigned long curr_temp;
- 
- 
-        addr = td_info->chnl_addr;
- 
-        /* Enable the msic for conversion before reading */
-        ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
-        if (ret)
-                return ret;
- 
-        /* Re-toggle the RRDATARD bit (temporary workaround) */
-        ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
-        if (ret)
-                return ret;
- 
-        /* Read the higher bits of data */
-        ret = intel_scu_ipc_ioread8(addr, &data);
-        if (ret)
-                return ret;
- 
-        /* Shift bits to accommodate the lower two data bits */
-        adc_val = (data << 2);
-        addr++;
- 
-        ret = intel_scu_ipc_ioread8(addr, &data);/* Read lower bits */
-        if (ret)
-                return ret;
- 
-        /* Adding lower two bits to the higher bits */
-        data &= 03;
-        adc_val += data;
- 
-        /* Convert ADC value to temperature */
-        ret = adc_to_temp(td_info->direct, adc_val, &curr_temp);
-        if (ret == 0)
-                *temp = td_info->curr_temp = curr_temp;
-        return ret;
+ 	struct thermal_device_info *td_info = tzd->devdata;
+ 	uint16_t adc_val, addr;
+ 	uint8_t data = 0;
+ 	int ret;
+ 	unsigned long curr_temp;
+ 
+ 
+ 	addr = td_info->chnl_addr;
+ 
+ 	/* Enable the msic for conversion before reading */
+ 	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
+ 	if (ret)
+ 		return ret;
+ 
+ 	/* Re-toggle the RRDATARD bit (temporary workaround) */
+ 	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
+ 	if (ret)
+ 		return ret;
+ 
+ 	/* Read the higher bits of data */
+ 	ret = intel_scu_ipc_ioread8(addr, &data);
+ 	if (ret)
+ 		return ret;
+ 
 -	/* Shift bits to accomodate the lower two data bits */
++	/* Shift bits to accommodate the lower two data bits */
+ 	adc_val = (data << 2);
+ 	addr++;
+ 
+ 	ret = intel_scu_ipc_ioread8(addr, &data);/* Read lower bits */
+ 	if (ret)
+ 		return ret;
+ 
+ 	/* Adding lower two bits to the higher bits */
+ 	data &= 03;
+ 	adc_val += data;
+ 
+ 	/* Convert ADC value to temperature */
+ 	ret = adc_to_temp(td_info->direct, adc_val, &curr_temp);
+ 	if (ret == 0)
+ 		*temp = td_info->curr_temp = curr_temp;
+ 	return ret;
  }
  
  /**
