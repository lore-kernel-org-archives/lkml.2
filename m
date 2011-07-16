Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1GPMho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:37:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48983 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab1GPMhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:37:12 -0400
Date: Sat, 16 Jul 2011 21:00:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the gpio tree with the i.MX tree
Message-Id: <20110716210022.eba63b058f7bf4aae583a35e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the gpio tree got a conflict in
arch/arm/mach-imx/mm-imx25.c, arch/arm/mach-imx/mm-imx31.c,
arch/arm/mach-imx/mm-imx35.c and arch/arm/mach-mx5/mm.c between commit
24b9ad95a692 ("ARM: mxc: clean up imx-dma device registration") from the
i.MX tree and commit e7fc6ae74467 ("gpio/mxc: get rid of the uses of
cpu_is_mx()") from the gpio tree.

Just context changes. I fixed them up (see below) and can carry the fixes
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mm-imx25.c
index 1e0c956,9a1591c..0000000
--- a/arch/arm/mach-imx/mm-imx25.c
+++ b/arch/arm/mach-imx/mm-imx25.c
@@@ -62,34 -61,11 +62,35 @@@ void __init mx25_init_irq(void
  	mxc_init_irq(MX25_IO_ADDRESS(MX25_AVIC_BASE_ADDR));
  }
  
 +static struct sdma_script_start_addrs imx25_sdma_script __initdata = {
 +	.ap_2_ap_addr = 729,
 +	.uart_2_mcu_addr = 904,
 +	.per_2_app_addr = 1255,
 +	.mcu_2_app_addr = 834,
 +	.uartsh_2_mcu_addr = 1120,
 +	.per_2_shp_addr = 1329,
 +	.mcu_2_shp_addr = 1048,
 +	.ata_2_mcu_addr = 1560,
 +	.mcu_2_ata_addr = 1479,
 +	.app_2_per_addr = 1189,
 +	.app_2_mcu_addr = 770,
 +	.shp_2_per_addr = 1407,
 +	.shp_2_mcu_addr = 979,
 +};
 +
 +static struct sdma_platform_data imx25_sdma_pdata __initdata = {
 +	.sdma_version = 2,
 +	.fw_name = "sdma-imx25.bin",
 +	.script_addrs = &imx25_sdma_script,
 +};
 +
  void __init imx25_soc_init(void)
  {
- 	mxc_register_gpio(0, MX25_GPIO1_BASE_ADDR, SZ_16K, MX25_INT_GPIO1, 0);
- 	mxc_register_gpio(1, MX25_GPIO2_BASE_ADDR, SZ_16K, MX25_INT_GPIO2, 0);
- 	mxc_register_gpio(2, MX25_GPIO3_BASE_ADDR, SZ_16K, MX25_INT_GPIO3, 0);
- 	mxc_register_gpio(3, MX25_GPIO4_BASE_ADDR, SZ_16K, MX25_INT_GPIO4, 0);
+ 	/* i.mx25 has the i.mx31 type gpio */
+ 	mxc_register_gpio("imx31-gpio", 0, MX25_GPIO1_BASE_ADDR, SZ_16K, MX25_INT_GPIO1, 0);
+ 	mxc_register_gpio("imx31-gpio", 1, MX25_GPIO2_BASE_ADDR, SZ_16K, MX25_INT_GPIO2, 0);
+ 	mxc_register_gpio("imx31-gpio", 2, MX25_GPIO3_BASE_ADDR, SZ_16K, MX25_INT_GPIO3, 0);
+ 	mxc_register_gpio("imx31-gpio", 3, MX25_GPIO4_BASE_ADDR, SZ_16K, MX25_INT_GPIO4, 0);
 +
 +	imx_add_imx_sdma(MX25_SDMA_BASE_ADDR, MX25_INT_SDMA, &imx25_sdma_pdata);
  }
diff --cc arch/arm/mach-imx/mm-imx31.c
index a1ff96f,6d103c0..0000000
--- a/arch/arm/mach-imx/mm-imx31.c
+++ b/arch/arm/mach-imx/mm-imx31.c
@@@ -58,35 -57,9 +58,35 @@@ void __init mx31_init_irq(void
  	mxc_init_irq(MX31_IO_ADDRESS(MX31_AVIC_BASE_ADDR));
  }
  
 +static struct sdma_script_start_addrs imx31_to1_sdma_script __initdata = {
 +	.per_2_per_addr = 1677,
 +};
 +
 +static struct sdma_script_start_addrs imx31_to2_sdma_script __initdata = {
 +	.ap_2_ap_addr = 423,
 +	.ap_2_bp_addr = 829,
 +	.bp_2_ap_addr = 1029,
 +};
 +
 +static struct sdma_platform_data imx31_sdma_pdata __initdata = {
 +	.sdma_version = 1,
 +	.fw_name = "sdma-imx31-to2.bin",
 +	.script_addrs = &imx31_to2_sdma_script,
 +};
 +
  void __init imx31_soc_init(void)
  {
 +	int to_version = mx31_revision() >> 4;
 +
- 	mxc_register_gpio(0, MX31_GPIO1_BASE_ADDR, SZ_16K, MX31_INT_GPIO1, 0);
- 	mxc_register_gpio(1, MX31_GPIO2_BASE_ADDR, SZ_16K, MX31_INT_GPIO2, 0);
- 	mxc_register_gpio(2, MX31_GPIO3_BASE_ADDR, SZ_16K, MX31_INT_GPIO3, 0);
+ 	mxc_register_gpio("imx31-gpio", 0, MX31_GPIO1_BASE_ADDR, SZ_16K, MX31_INT_GPIO1, 0);
+ 	mxc_register_gpio("imx31-gpio", 1, MX31_GPIO2_BASE_ADDR, SZ_16K, MX31_INT_GPIO2, 0);
+ 	mxc_register_gpio("imx31-gpio", 2, MX31_GPIO3_BASE_ADDR, SZ_16K, MX31_INT_GPIO3, 0);
 +
 +	if (to_version == 1) {
 +		strncpy(imx31_sdma_pdata.fw_name, "sdma-imx31-to1.bin",
 +			strlen(imx31_sdma_pdata.fw_name));
 +		imx31_sdma_pdata.script_addrs = &imx31_to1_sdma_script;
 +	}
 +
 +	imx_add_imx_sdma(MX31_SDMA_BASE_ADDR, MX31_INT_SDMA, &imx31_sdma_pdata);
  }
diff --cc arch/arm/mach-imx/mm-imx35.c
index da530ca,bb068bc..0000000
--- a/arch/arm/mach-imx/mm-imx35.c
+++ b/arch/arm/mach-imx/mm-imx35.c
@@@ -55,55 -54,10 +55,56 @@@ void __init mx35_init_irq(void
  	mxc_init_irq(MX35_IO_ADDRESS(MX35_AVIC_BASE_ADDR));
  }
  
 +static struct sdma_script_start_addrs imx35_to1_sdma_script __initdata = {
 +	.ap_2_ap_addr = 642,
 +	.uart_2_mcu_addr = 817,
 +	.mcu_2_app_addr = 747,
 +	.uartsh_2_mcu_addr = 1183,
 +	.per_2_shp_addr = 1033,
 +	.mcu_2_shp_addr = 961,
 +	.ata_2_mcu_addr = 1333,
 +	.mcu_2_ata_addr = 1252,
 +	.app_2_mcu_addr = 683,
 +	.shp_2_per_addr = 1111,
 +	.shp_2_mcu_addr = 892,
 +};
 +
 +static struct sdma_script_start_addrs imx35_to2_sdma_script __initdata = {
 +	.ap_2_ap_addr = 729,
 +	.uart_2_mcu_addr = 904,
 +	.per_2_app_addr = 1597,
 +	.mcu_2_app_addr = 834,
 +	.uartsh_2_mcu_addr = 1270,
 +	.per_2_shp_addr = 1120,
 +	.mcu_2_shp_addr = 1048,
 +	.ata_2_mcu_addr = 1429,
 +	.mcu_2_ata_addr = 1339,
 +	.app_2_per_addr = 1531,
 +	.app_2_mcu_addr = 770,
 +	.shp_2_per_addr = 1198,
 +	.shp_2_mcu_addr = 979,
 +};
 +
 +static struct sdma_platform_data imx35_sdma_pdata __initdata = {
 +	.sdma_version = 2,
 +	.fw_name = "sdma-imx35-to2.bin",
 +	.script_addrs = &imx35_to2_sdma_script,
 +};
 +
  void __init imx35_soc_init(void)
  {
 +	int to_version = mx35_revision() >> 4;
 +
- 	mxc_register_gpio(0, MX35_GPIO1_BASE_ADDR, SZ_16K, MX35_INT_GPIO1, 0);
- 	mxc_register_gpio(1, MX35_GPIO2_BASE_ADDR, SZ_16K, MX35_INT_GPIO2, 0);
- 	mxc_register_gpio(2, MX35_GPIO3_BASE_ADDR, SZ_16K, MX35_INT_GPIO3, 0);
+ 	/* i.mx35 has the i.mx31 type gpio */
+ 	mxc_register_gpio("imx31-gpio", 0, MX35_GPIO1_BASE_ADDR, SZ_16K, MX35_INT_GPIO1, 0);
+ 	mxc_register_gpio("imx31-gpio", 1, MX35_GPIO2_BASE_ADDR, SZ_16K, MX35_INT_GPIO2, 0);
+ 	mxc_register_gpio("imx31-gpio", 2, MX35_GPIO3_BASE_ADDR, SZ_16K, MX35_INT_GPIO3, 0);
 +
 +	if (to_version == 1) {
 +		strncpy(imx35_sdma_pdata.fw_name, "sdma-imx35-to1.bin",
 +			strlen(imx35_sdma_pdata.fw_name));
 +		imx35_sdma_pdata.script_addrs = &imx35_to1_sdma_script;
 +	}
 +
 +	imx_add_imx_sdma(MX35_SDMA_BASE_ADDR, MX35_INT_SDMA, &imx35_sdma_pdata);
  }
diff --cc arch/arm/mach-mx5/mm.c
index 1b7059f,665843d..0000000
--- a/arch/arm/mach-mx5/mm.c
+++ b/arch/arm/mach-mx5/mm.c
@@@ -101,64 -100,23 +101,66 @@@ void __init mx53_init_irq(void
  	tzic_init_irq(tzic_virt);
  }
  
 +static struct sdma_script_start_addrs imx51_sdma_script __initdata = {
 +	.ap_2_ap_addr = 642,
 +	.uart_2_mcu_addr = 817,
 +	.mcu_2_app_addr = 747,
 +	.mcu_2_shp_addr = 961,
 +	.ata_2_mcu_addr = 1473,
 +	.mcu_2_ata_addr = 1392,
 +	.app_2_per_addr = 1033,
 +	.app_2_mcu_addr = 683,
 +	.shp_2_per_addr = 1251,
 +	.shp_2_mcu_addr = 892,
 +};
 +
 +static struct sdma_platform_data imx51_sdma_pdata __initdata = {
 +	.sdma_version = 2,
 +	.fw_name = "sdma-imx51.bin",
 +	.script_addrs = &imx51_sdma_script,
 +};
 +
 +static struct sdma_script_start_addrs imx53_sdma_script __initdata = {
 +	.ap_2_ap_addr = 642,
 +	.app_2_mcu_addr = 683,
 +	.mcu_2_app_addr = 747,
 +	.uart_2_mcu_addr = 817,
 +	.shp_2_mcu_addr = 891,
 +	.mcu_2_shp_addr = 960,
 +	.uartsh_2_mcu_addr = 1032,
 +	.spdif_2_mcu_addr = 1100,
 +	.mcu_2_spdif_addr = 1134,
 +	.firi_2_mcu_addr = 1193,
 +	.mcu_2_firi_addr = 1290,
 +};
 +
 +static struct sdma_platform_data imx53_sdma_pdata __initdata = {
 +	.sdma_version = 2,
 +	.fw_name = "sdma-imx53.bin",
 +	.script_addrs = &imx53_sdma_script,
 +};
 +
  void __init imx51_soc_init(void)
  {
- 	mxc_register_gpio(0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
- 	mxc_register_gpio(1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
- 	mxc_register_gpio(2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
- 	mxc_register_gpio(3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
+ 	/* i.mx51 has the i.mx31 type gpio */
+ 	mxc_register_gpio("imx31-gpio", 0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
+ 	mxc_register_gpio("imx31-gpio", 1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
+ 	mxc_register_gpio("imx31-gpio", 2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
+ 	mxc_register_gpio("imx31-gpio", 3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
 +
 +	imx_add_imx_sdma(MX51_SDMA_BASE_ADDR, MX51_INT_SDMA, &imx51_sdma_pdata);
  }
  
  void __init imx53_soc_init(void)
  {
- 	mxc_register_gpio(0, MX53_GPIO1_BASE_ADDR, SZ_16K, MX53_INT_GPIO1_LOW, MX53_INT_GPIO1_HIGH);
- 	mxc_register_gpio(1, MX53_GPIO2_BASE_ADDR, SZ_16K, MX53_INT_GPIO2_LOW, MX53_INT_GPIO2_HIGH);
- 	mxc_register_gpio(2, MX53_GPIO3_BASE_ADDR, SZ_16K, MX53_INT_GPIO3_LOW, MX53_INT_GPIO3_HIGH);
- 	mxc_register_gpio(3, MX53_GPIO4_BASE_ADDR, SZ_16K, MX53_INT_GPIO4_LOW, MX53_INT_GPIO4_HIGH);
- 	mxc_register_gpio(4, MX53_GPIO5_BASE_ADDR, SZ_16K, MX53_INT_GPIO5_LOW, MX53_INT_GPIO5_HIGH);
- 	mxc_register_gpio(5, MX53_GPIO6_BASE_ADDR, SZ_16K, MX53_INT_GPIO6_LOW, MX53_INT_GPIO6_HIGH);
- 	mxc_register_gpio(6, MX53_GPIO7_BASE_ADDR, SZ_16K, MX53_INT_GPIO7_LOW, MX53_INT_GPIO7_HIGH);
+ 	/* i.mx53 has the i.mx31 type gpio */
+ 	mxc_register_gpio("imx31-gpio", 0, MX53_GPIO1_BASE_ADDR, SZ_16K, MX53_INT_GPIO1_LOW, MX53_INT_GPIO1_HIGH);
+ 	mxc_register_gpio("imx31-gpio", 1, MX53_GPIO2_BASE_ADDR, SZ_16K, MX53_INT_GPIO2_LOW, MX53_INT_GPIO2_HIGH);
+ 	mxc_register_gpio("imx31-gpio", 2, MX53_GPIO3_BASE_ADDR, SZ_16K, MX53_INT_GPIO3_LOW, MX53_INT_GPIO3_HIGH);
+ 	mxc_register_gpio("imx31-gpio", 3, MX53_GPIO4_BASE_ADDR, SZ_16K, MX53_INT_GPIO4_LOW, MX53_INT_GPIO4_HIGH);
+ 	mxc_register_gpio("imx31-gpio", 4, MX53_GPIO5_BASE_ADDR, SZ_16K, MX53_INT_GPIO5_LOW, MX53_INT_GPIO5_HIGH);
+ 	mxc_register_gpio("imx31-gpio", 5, MX53_GPIO6_BASE_ADDR, SZ_16K, MX53_INT_GPIO6_LOW, MX53_INT_GPIO6_HIGH);
+ 	mxc_register_gpio("imx31-gpio", 6, MX53_GPIO7_BASE_ADDR, SZ_16K, MX53_INT_GPIO7_LOW, MX53_INT_GPIO7_HIGH);
 +
 +	imx_add_imx_sdma(MX53_SDMA_BASE_ADDR, MX53_INT_SDMA, &imx53_sdma_pdata);
  }
