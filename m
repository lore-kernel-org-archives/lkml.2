Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2EBHtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 03:49:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52126 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2EBHte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 03:49:34 -0400
X-AuditID: cbfee61b-b7ce2ae00000583e-43-4fa0e70c0dce
Message-id: <4FA0E706.8060700@samsung.com>
Date: Wed, 02 May 2012 16:49:26 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
MIME-version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-mmc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/7] mmc: dw_mmc: add samsung exynos5250 specific extentions
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
 <1335935266-25289-5-git-send-email-thomas.abraham@linaro.org>
 <CAH9JG2XBinh=XAVnt3EnWrEqeTKz34d9yB6wfiuF-J-Se_Q__Q@mail.gmail.com>
In-reply-to: <CAH9JG2XBinh=XAVnt3EnWrEqeTKz34d9yB6wfiuF-J-Se_Q__Q@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 04:01 PM, Kyungmin Park wrote:

> Hi,
> 
> On 5/2/12, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>> The instantiation of the Synopsis Designware controller on Exynos5250
>> include extension for SDR and DDR specific tx/rx phase shift timing
>> and CIU internal divider. In addition to that, the option to skip the
>> command hold stage is also introduced. Add support for these Exynos5250
>> specfic extenstions.
>>
>> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> ---
>>  .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |   33
>> +++++++++++++++++++-
>>  drivers/mmc/host/dw_mmc-pltfm.c                    |    8 +++++
>>  drivers/mmc/host/dw_mmc.c                          |   32
>> ++++++++++++++++++-
>>  drivers/mmc/host/dw_mmc.h                          |   13 ++++++++
>>  include/linux/mmc/dw_mmc.h                         |    6 +++
>>  5 files changed, 89 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>> b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>> index c1ed70e..465fc31 100644
>> --- a/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>> +++ b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>> @@ -7,6 +7,8 @@ Required Properties:
>>
>>  * compatible: should be one of the following
>>  	- synopsis,dw-mshc: for controllers compliant with synopsis dw-mshc.
>> +	- synopsis,dw-mshc-exynos5250: for controllers with Samsung
>> +	  Exynos5250 specific extentions.
>>
>>  * reg: physical base address of the dw-mshc controller and size of its
>> memory
>>    region.
>> @@ -55,13 +57,40 @@ Optional properties:
>>  * no-write-protect: The write protect pad of the controller is not
>> connected
>>    to the write protect pin on the slot.
>>
>> +Samsung Exynos5250 specific properties:
>> +
>> +* samsung,dw-mshc-sdr-timing: Specifies the value of CUI clock divider,
>> CIU
>> +  clock phase shift value in transmit mode and CIU clock phase shift value
>> in
>> +  receive mode for single data rate mode operation. Refer notes of the
>> valid
>> +  values below.
>> +
>> +* samsung,dw-mshc-ddr-timing: Specifies the value of CUI clock divider,
>> CIU
>> +  clock phase shift value in transmit mode and CIU clock phase shift value
>> in
>> +  receive mode for double data rate mode operation. Refer notes of the
>> valid
>> +  values below. The order of the cells should be
>> +
>> +    - First Cell: 	CIU clock divider value.
>> +    - Second Cell:	CIU clock phase shift value for tx mode.
>> +    - Third Cell:	CIU clock phase shift value for rx mode.
>> +
>> +  Valid values for SDR and DDR CIU clock timing:
>> +
>> +    - valid values for CIU clock divider, tx phase shift and rx phase
>> shift
>> +      is 0 to 7.
>> +
>> +    - When CIU clock divider value is set to 3, all possible 8 phase shift
>> +      values can be used.
>> +
>> +    - If CIU clock divider value is 0 (that is divide by 1), both tx and
>> rx
>> +      phase shift clocks should be 0.
>> +
>>  Example:
>>
>>    The MSHC controller node can be split into two portions, SoC specific
>> and
>>    board specific portions as listed below.
>>
>>  	dwmmc0@12200000 {
>> -		compatible = "synopsis,dw-mshc";
>> +		compatible = "synopsis,dw-mshc-exynos5250";
>>  		reg = <0x12200000 0x1000>;
>>  		interrupts = <0 75 0>;
>>  	};
>> @@ -72,6 +101,8 @@ Example:
>>  		no-write-protect;
>>  		fifo-depth = <0x80>;
>>  		card-detect-delay = <200>;
>> +		samsung,dw-mshc-sdr-timing = <2 3 3>;
>> +		samsung,dw-mshc-ddr-timing = <1 2 3>;
>>
>>  		slot0 {
>>  			bus-width = <8>;
>> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c
>> b/drivers/mmc/host/dw_mmc-pltfm.c
>> index 2b2c9bd..35056fd 100644
>> --- a/drivers/mmc/host/dw_mmc-pltfm.c
>> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
>> @@ -27,9 +27,17 @@ static struct dw_mci_drv_data synopsis_drv_data = {
>>  	.ctrl_type	= DW_MCI_TYPE_SYNOPSIS,
>>  };
>>
>> +static struct dw_mci_drv_data exynos5250_drv_data = {
>> +	.ctrl_type	= DW_MCI_TYPE_EXYNOS5250,
>> +	.caps		= MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
>> +				MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
> These caps should be board specific. So it's not proper place. Esp.,
> MMC_CAP_8_BIT_DATA.
>> +};
>> +
>>  static const struct of_device_id dw_mci_pltfm_match[] = {
>>  	{ .compatible = "synopsis,dw-mshc",
>>  			.data = (void *)&synopsis_drv_data, },
>> +	{ .compatible = "synopsis,dw-mshc-exynos5250",
>> +			.data = (void *)&exynos5250_drv_data, },
>>  	{},
>>  };
>>  MODULE_DEVICE_TABLE(of, dw_mci_pltfm_match);
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index bcf66d7..9174a69 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -236,6 +236,7 @@ static void dw_mci_set_timeout(struct dw_mci *host)
>>  static u32 dw_mci_prepare_command(struct mmc_host *mmc, struct mmc_command
>> *cmd)
>>  {
>>  	struct mmc_data	*data;
>> +	struct dw_mci_slot *slot = mmc_priv(mmc);
>>  	u32 cmdr;
>>  	cmd->error = -EINPROGRESS;
>>
>> @@ -265,6 +266,10 @@ static u32 dw_mci_prepare_command(struct mmc_host *mmc,
>> struct mmc_command *cmd)
>>  			cmdr |= SDMMC_CMD_DAT_WR;
>>  	}
>>
>> +	if (slot->host->drv_data->ctrl_type == DW_MCI_TYPE_EXYNOS5250)
>> +		if (SDMMC_CLKSEL_GET_SELCLK_DRV(mci_readl(slot->host, CLKSEL)))
>> +			cmdr |= SDMMC_USE_HOLD_REG;
> Some other board, custom SOC also can use this HOLD register. So it's
> not EXYNOS5250 specific one. I think we introduce the more generic
> quirks for this instead of SOC specific.

One more, I think that also need to check the IMPLEMENT_HOLD_REG bit in HCON register.
It has dependency with that.
As Mr.Park is mentioned, this register is clock phasing.
In spec, card is enumerated in SDR12 or SDR25 mode, the application must program the use_hold_reg.

Best Regards,
Jaehoon Chung

>> +
>>  	return cmdr;
>>  }
>>
>> @@ -787,10 +792,19 @@ static void dw_mci_set_ios(struct mmc_host *mmc,
>> struct mmc_ios *ios)
>>  	regs = mci_readl(slot->host, UHS_REG);
>>
>>  	/* DDR mode set */
>> -	if (ios->timing == MMC_TIMING_UHS_DDR50)
>> +	if (ios->timing == MMC_TIMING_UHS_DDR50) {
>>  		regs |= (0x1 << slot->id) << 16;
>> -	else
>> +		mci_writel(slot->host, CLKSEL, slot->host->ddr_timing);
> As you wrote, does CLKSEL is some SOC specific registers?
>> +	} else {
>>  		regs &= ~(0x1 << slot->id) << 16;
>> +		mci_writel(slot->host, CLKSEL, slot->host->sdr_timing);
>> +	}
>> +
>> +	if (slot->host->drv_data->ctrl_type == DW_MCI_TYPE_EXYNOS5250) {
>> +		slot->host->bus_hz = clk_get_rate(slot->host->ciu_clk);
>> +		slot->host->bus_hz /= SDMMC_CLKSEL_GET_DIVRATIO(
>> +					mci_readl(slot->host, CLKSEL));
>> +	}
>>
>>  	mci_writel(slot->host, UHS_REG, regs);
>>
>> @@ -2074,6 +2088,20 @@ static struct dw_mci_board *dw_mci_parse_dt(struct
>> dw_mci *host)
>>  		if (of_get_property(np, of_quriks[idx].quirk, NULL))
>>  			pdata->quirks |= of_quriks[idx].id;
>>
>> +	if (of_property_read_u32_array(dev->of_node,
>> +			"samsung,dw-mshc-sdr-timing", timing, 3))
>> +		host->sdr_timing = DW_MCI_DEF_SDR_TIMING;
>> +	else
>> +		host->sdr_timing = SDMMC_CLKSEL_TIMING(timing[0],
>> +					timing[1], timing[2]);
>> +
>> +	if (of_property_read_u32_array(dev->of_node,
>> +			"samsung,dw-mshc-ddr-timing", timing, 3))
>> +		host->ddr_timing = DW_MCI_DEF_DDR_TIMING;
>> +	else
>> +		host->ddr_timing = SDMMC_CLKSEL_TIMING(timing[0],
>> +					timing[1], timing[2]);
>> +
>>  	if (of_property_read_u32(np, "fifo-depth", &pdata->fifo_depth))
>>  		dev_info(dev, "fifo-depth property not found, using "
>>  				"value of FIFOTH register as default\n");
>> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
>> index 8b8862b..4b7e42b 100644
>> --- a/drivers/mmc/host/dw_mmc.h
>> +++ b/drivers/mmc/host/dw_mmc.h
>> @@ -53,6 +53,7 @@
>>  #define SDMMC_IDINTEN		0x090
>>  #define SDMMC_DSCADDR		0x094
>>  #define SDMMC_BUFADDR		0x098
>> +#define SDMMC_CLKSEL		0x09C /* specific to Samsung Exynos5250 */
> Another Samsung Custom SOC also used it.
>>  #define SDMMC_DATA(x)		(x)
>>
>>  /*
>> @@ -111,6 +112,7 @@
>>  #define SDMMC_INT_ERROR			0xbfc2
>>  /* Command register defines */
>>  #define SDMMC_CMD_START			BIT(31)
>> +#define SDMMC_USE_HOLD_REG		BIT(29)
>>  #define SDMMC_CMD_CCS_EXP		BIT(23)
>>  #define SDMMC_CMD_CEATA_RD		BIT(22)
>>  #define SDMMC_CMD_UPD_CLK		BIT(21)
>> @@ -142,6 +144,17 @@
>>  /* Version ID register define */
>>  #define SDMMC_GET_VERID(x)		((x) & 0xFFFF)
>>
>> +#define DW_MCI_DEF_SDR_TIMING		0x03030002
>> +#define DW_MCI_DEF_DDR_TIMING		0x03020001
>> +#define SDMMC_CLKSEL_CCLK_SAMPLE(x)	(((x) & 3) << 0)
>> +#define SDMMC_CLKSEL_CCLK_DRIVE(x)	(((x) & 3) << 16)
>> +#define SDMMC_CLKSEL_CCLK_DIVIDER(x)	(((x) & 3) << 24)
>> +#define SDMMC_CLKSEL_TIMING(x, y, z)	(SDMMC_CLKSEL_CCLK_SAMPLE(x) |	\
>> +					SDMMC_CLKSEL_CCLK_DRIVE(y) |	\
>> +					SDMMC_CLKSEL_CCLK_DIVIDER(z))
>> +#define SDMMC_CLKSEL_GET_DIVRATIO(x)	((((x) >> 24) & 0x7) + 1)
>> +#define SDMMC_CLKSEL_GET_SELCLK_DRV(x)	(((x) >> 16) & 0x7)
>> +
>>  /* Register access macros */
>>  #define mci_readl(dev, reg)			\
>>  	__raw_readl((dev)->regs + SDMMC_##reg)
>> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
>> index 71d2b56..6e6d036 100644
>> --- a/include/linux/mmc/dw_mmc.h
>> +++ b/include/linux/mmc/dw_mmc.h
>> @@ -82,6 +82,8 @@ struct mmc_data;
>>   * @biu_clk: Pointer to bus interface unit clock instance.
>>   * @ciu_clk: Pointer to card interface unit clock instance.
>>   * @slot: Slots sharing this MMC controller.
>> + * @sdr_timing: Clock phase shifting for driving and sampling in sdr mode
>> + * @ddr_timing: Clock phase shifting for driving and sampling in ddr mode
>>   * @fifo_depth: depth of FIFO.
>>   * @data_shift: log2 of FIFO item size.
>>   * @part_buf_start: Start index in part_buf.
>> @@ -166,6 +168,10 @@ struct dw_mci {
>>  	struct clk		*ciu_clk;
>>  	struct dw_mci_slot	*slot[MAX_MCI_SLOTS];
>>
>> +	/* Phase Shift Value (for exynos5250 variant) */
>> +	u32			sdr_timing;
>> +	u32			ddr_timing;
>> +
>>  	/* FIFO push and pull */
>>  	int			fifo_depth;
>>  	int			data_shift;
>> --
>> 1.7.5.4
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


