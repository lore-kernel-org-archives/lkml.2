Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502Ab2ERBhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 21:37:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24605 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760971Ab2ERBhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 21:37:04 -0400
X-AuditID: cbfee61b-b7bb6ae0000006fb-a8-4fb5a7be047b
Message-id: <4FB5A799.6070700@samsung.com>
Date: Fri, 18 May 2012 10:36:25 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
MIME-version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: Re: [PATCH v2 6/6] mmc: dw_mmc: add samsung exynos5250 specific
 extentions
References: <1337267411-28226-1-git-send-email-thomas.abraham@linaro.org>
 <1337267411-28226-7-git-send-email-thomas.abraham@linaro.org>
In-reply-to: <1337267411-28226-7-git-send-email-thomas.abraham@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 05/18/2012 12:10 AM, Thomas Abraham wrote:

> The instantiation of the Synopsis Designware controller on Exynos5250
> include extension for SDR and DDR specific tx/rx phase shift timing
> and CIU internal divider. In addition to that, the option to skip the
> command hold stage is also introduced. Add support for these Exynos5250
> specfic extenstions.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |   33 ++++++++++++++++-
>  drivers/mmc/host/dw_mmc-pltfm.c                    |   15 +++++++
>  drivers/mmc/host/dw_mmc.c                          |   40 +++++++++++++++++++-
>  drivers/mmc/host/dw_mmc.h                          |   14 +++++++
>  include/linux/mmc/dw_mmc.h                         |    6 +++
>  5 files changed, 105 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
> index 3acd6c9..99b166e 100644
> --- a/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
> +++ b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
> @@ -7,6 +7,8 @@ Required Properties:
>  
>  * compatible: should be one of the following
>  	- snps,dw-mshc: for controllers compliant with synopsis dw-mshc.
> +	- samsung,exynos5250-dw-mshc: for controllers with Samsung
> +	  Exynos5250 specific extentions.
>  
>  * reg: physical base address of the dw-mshc controller and size of its memory
>    region.
> @@ -74,13 +76,40 @@ Aliases:
>    the following format 'mshc{n}' where n is a unique number for the alias.
>  
>  
> +Samsung Exynos5250 specific properties:
> +
> +* samsung,dw-mshc-sdr-timing: Specifies the value of CUI clock divider, CIU
> +  clock phase shift value in transmit mode and CIU clock phase shift value in
> +  receive mode for single data rate mode operation. Refer notes of the valid
> +  values below.
> +
> +* samsung,dw-mshc-ddr-timing: Specifies the value of CUI clock divider, CIU
> +  clock phase shift value in transmit mode and CIU clock phase shift value in
> +  receive mode for double data rate mode operation. Refer notes of the valid
> +  values below. The order of the cells should be
> +
> +    - First Cell: 	CIU clock divider value.
> +    - Second Cell:	CIU clock phase shift value for tx mode.
> +    - Third Cell:	CIU clock phase shift value for rx mode.
> +
> +  Valid values for SDR and DDR CIU clock timing:
> +
> +    - valid values for CIU clock divider, tx phase shift and rx phase shift
> +      is 0 to 7.
> +
> +    - When CIU clock divider value is set to 3, all possible 8 phase shift
> +      values can be used.
> +
> +    - If CIU clock divider value is 0 (that is divide by 1), both tx and rx
> +      phase shift clocks should be 0.
> +
>  Example:
>  
>    The MSHC controller node can be split into two portions, SoC specific and
>    board specific portions as listed below.
>  
>  	dwmmc0@12200000 {
> -		compatible = "snps,dw-mshc";
> +		compatible = "samsung,exynos5250-dw-mshc";
>  		reg = <0x12200000 0x1000>;
>  		interrupts = <0 75 0>;
>  		#address-cells = <1>;
> @@ -94,6 +123,8 @@ Example:
>  		no-write-protect;
>  		fifo-depth = <0x80>;
>  		card-detect-delay = <200>;
> +		samsung,dw-mshc-sdr-timing = <2 3 3>;
> +		samsung,dw-mshc-ddr-timing = <1 2 3>;
>  
>  		slot@0 {
>  			reg = <0>;
> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
> index 8d24f6d..900f412 100644
> --- a/drivers/mmc/host/dw_mmc-pltfm.c
> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> @@ -27,9 +27,24 @@ static struct dw_mci_drv_data synopsis_drv_data = {
>  	.ctrl_type	= DW_MCI_TYPE_SYNOPSIS,
>  };
>  
> +static unsigned long exynos5250_dwmmc_caps[4] = {
> +	MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
> +		MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
> +	MMC_CAP_CMD23,
> +	MMC_CAP_CMD23,
> +	MMC_CAP_CMD23,
> +};
> +
> +static struct dw_mci_drv_data exynos5250_drv_data = {
> +	.ctrl_type	= DW_MCI_TYPE_EXYNOS5250,
> +	.caps		= exynos5250_dwmmc_caps,
> +};
> +
>  static const struct of_device_id dw_mci_pltfm_match[] = {
>  	{ .compatible = "snps,dw-mshc",
>  			.data = (void *)&synopsis_drv_data, },
> +	{ .compatible = "samsung,exynos5250-dw-mshc",
> +			.data = (void *)&exynos5250_drv_data, },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, dw_mci_pltfm_match);
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 0317287..58bab5b 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -236,6 +236,7 @@ static void dw_mci_set_timeout(struct dw_mci *host)
>  static u32 dw_mci_prepare_command(struct mmc_host *mmc, struct mmc_command *cmd)
>  {
>  	struct mmc_data	*data;
> +	struct dw_mci_slot *slot = mmc_priv(mmc);
>  	u32 cmdr;
>  	cmd->error = -EINPROGRESS;
>  
> @@ -265,6 +266,17 @@ static u32 dw_mci_prepare_command(struct mmc_host *mmc, struct mmc_command *cmd)
>  			cmdr |= SDMMC_CMD_DAT_WR;
>  	}
>  
> +	/*
> +	 * Samsung Exynos5250 extends the use of CMD register with the use of
> +	 * bit 29 (which is reserved on standard MSHC controllers) for
> +	 * optionally bypassing the HOLD register for command and data. The
> +	 * HOLD register should be bypassed in case there is no phase shift
> +	 * applied on CMD/DATA that is sent to the card.
> +	 */
> +	if (slot->host->drv_data->ctrl_type == DW_MCI_TYPE_EXYNOS5250)
> +		if (SDMMC_CLKSEL_GET_SELCLK_DRV(mci_readl(slot->host, CLKSEL)))
> +			cmdr |= SDMMC_CMD_USE_HOLD_REG;
> +
>  	return cmdr;
>  }
>  
> @@ -787,10 +799,19 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  	regs = mci_readl(slot->host, UHS_REG);
>  
>  	/* DDR mode set */
> -	if (ios->timing == MMC_TIMING_UHS_DDR50)
> +	if (ios->timing == MMC_TIMING_UHS_DDR50) {
>  		regs |= (0x1 << slot->id) << 16;
> -	else
> +		mci_writel(slot->host, CLKSEL, slot->host->ddr_timing);
> +	} else {
>  		regs &= ~(0x1 << slot->id) << 16;
> +		mci_writel(slot->host, CLKSEL, slot->host->sdr_timing);
> +	}
> +
> +	if (slot->host->drv_data->ctrl_type == DW_MCI_TYPE_EXYNOS5250) {
> +		slot->host->bus_hz = clk_get_rate(slot->host->ciu_clk);
> +		slot->host->bus_hz /= SDMMC_CLKSEL_GET_DIVRATIO(
> +					mci_readl(slot->host, CLKSEL));
> +	}
>  
>  	mci_writel(slot->host, UHS_REG, regs);
>  
> @@ -2076,6 +2097,7 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>  	struct dw_mci_board *pdata;
>  	struct device *dev = host->dev;
>  	struct device_node *np = dev->of_node;
> +	u32 timing[3];
>  	int idx, cnt;
>  
>  	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> @@ -2098,6 +2120,20 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
>  		if (of_get_property(np, of_quriks[idx].quirk, NULL))
>  			pdata->quirks |= of_quriks[idx].id;
>  
> +	if (of_property_read_u32_array(dev->of_node,
> +			"samsung,dw-mshc-sdr-timing", timing, 3))
> +		host->sdr_timing = DW_MCI_DEF_SDR_TIMING;
> +	else
> +		host->sdr_timing = SDMMC_CLKSEL_TIMING(timing[0],
> +					timing[1], timing[2]);
> +
> +	if (of_property_read_u32_array(dev->of_node,
> +			"samsung,dw-mshc-ddr-timing", timing, 3))
> +		host->ddr_timing = DW_MCI_DEF_DDR_TIMING;
> +	else
> +		host->ddr_timing = SDMMC_CLKSEL_TIMING(timing[0],
> +					timing[1], timing[2]);
> +
>  	if (of_property_read_u32(np, "fifo-depth", &pdata->fifo_depth))
>  		dev_info(dev, "fifo-depth property not found, using "
>  				"value of FIFOTH register as default\n");
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 1ecaa02..6c17282 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -53,6 +53,7 @@
>  #define SDMMC_IDINTEN		0x090
>  #define SDMMC_DSCADDR		0x094
>  #define SDMMC_BUFADDR		0x098
> +#define SDMMC_CLKSEL		0x09C /* specific to Samsung Exynos5250 */
>  #define SDMMC_DATA(x)		(x)

I know that didn't use to specific field(CLKSEL register) for only Samsung Exynos5250.
Maybe it should be used to Samsung-SoC.

>  
>  /*
> @@ -111,6 +112,7 @@
>  #define SDMMC_INT_ERROR			0xbfc2
>  /* Command register defines */
>  #define SDMMC_CMD_START			BIT(31)
> +#define SDMMC_CMD_USE_HOLD_REG		BIT(29)
>  #define SDMMC_CMD_CCS_EXP		BIT(23)
>  #define SDMMC_CMD_CEATA_RD		BIT(22)
>  #define SDMMC_CMD_UPD_CLK		BIT(21)
> @@ -142,6 +144,17 @@
>  /* Version ID register define */
>  #define SDMMC_GET_VERID(x)		((x) & 0xFFFF)
>  
> +#define DW_MCI_DEF_SDR_TIMING		0x03030002
> +#define DW_MCI_DEF_DDR_TIMING		0x03020001
> +#define SDMMC_CLKSEL_CCLK_SAMPLE(x)	(((x) & 3) << 0)
> +#define SDMMC_CLKSEL_CCLK_DRIVE(x)	(((x) & 3) << 16)
> +#define SDMMC_CLKSEL_CCLK_DIVIDER(x)	(((x) & 3) << 24)
> +#define SDMMC_CLKSEL_TIMING(x, y, z)	(SDMMC_CLKSEL_CCLK_SAMPLE(x) |	\
> +					SDMMC_CLKSEL_CCLK_DRIVE(y) |	\
> +					SDMMC_CLKSEL_CCLK_DIVIDER(z))
> +#define SDMMC_CLKSEL_GET_DIVRATIO(x)	((((x) >> 24) & 0x7) + 1)
> +#define SDMMC_CLKSEL_GET_SELCLK_DRV(x)	(((x) >> 16) & 0x7)
> +
>  /* Register access macros */
>  #define mci_readl(dev, reg)			\
>  	__raw_readl((dev)->regs + SDMMC_##reg)
> @@ -184,6 +197,7 @@ extern int dw_mci_resume(struct dw_mci *host);
>  
>  /* Variations in the dw_mci controller */
>  #define DW_MCI_TYPE_SYNOPSIS		0
> +#define DW_MCI_TYPE_EXYNOS5250		1 /* Samsung Exynos5250 Extensions */
>  
>  /* dw_mci platform driver data */
>  struct dw_mci_drv_data {
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index ae45e4f..32c778f 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -82,6 +82,8 @@ struct mmc_data;
>   * @biu_clk: Pointer to bus interface unit clock instance.
>   * @ciu_clk: Pointer to card interface unit clock instance.
>   * @slot: Slots sharing this MMC controller.
> + * @sdr_timing: Clock phase shifting for driving and sampling in sdr mode
> + * @ddr_timing: Clock phase shifting for driving and sampling in ddr mode
>   * @fifo_depth: depth of FIFO.
>   * @data_shift: log2 of FIFO item size.
>   * @part_buf_start: Start index in part_buf.
> @@ -166,6 +168,10 @@ struct dw_mci {
>  	struct clk		*ciu_clk;
>  	struct dw_mci_slot	*slot[MAX_MCI_SLOTS];
>  
> +	/* Phase Shift Value (for exynos5250 variant) */
> +	u32			sdr_timing;
> +	u32			ddr_timing;
> +
>  	/* FIFO push and pull */
>  	int			fifo_depth;
>  	int			data_shift;


