Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1LNCUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:20:12 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:1670 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753457Ab1LNCUJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:20:09 -0500
X-SpamScore: -2
X-BigFish: VS-2(zzc89bh1432Nzz1202h1082kzz8275dhz2dh2a8h668h839h941hb79i61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EE807EF.4090109@freescale.com>
Date: Wed, 14 Dec 2011 10:20:31 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Vinod Koul <vinod.koul@intel.com>, Chris Ball <cjb@laptop.org>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>,
        <linux-mmc@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] mtd: gpmi-nand: move to dma_transfer_direction
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org> <1323791286-29574-5-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1323791286-29574-5-git-send-email-shawn.guo@linaro.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月13日 23:48, Shawn Guo 写道:
> This patch fixes usage of dma direction to adopt dma_transfer_direction.
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c |   22 ++++++++++++----------
>  1 files changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> index de4db76..c4c4d6d 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> @@ -827,7 +827,7 @@ int gpmi_send_command(struct gpmi_nand_data *this)
>  	pio[1] = pio[2] = 0;
>  	desc = channel->device->device_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
> -					ARRAY_SIZE(pio), DMA_NONE, 0);
> +					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
>  	if (!desc) {
>  		pr_err("step 1 error\n");
>  		return -1;
> @@ -839,7 +839,7 @@ int gpmi_send_command(struct gpmi_nand_data *this)
>  	sg_init_one(sgl, this->cmd_buffer, this->command_length);
>  	dma_map_sg(this->dev, sgl, 1, DMA_TO_DEVICE);
>  	desc = channel->device->device_prep_slave_sg(channel,
> -					sgl, 1, DMA_TO_DEVICE, 1);
> +					sgl, 1, DMA_MEM_TO_DEV, 1);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -872,7 +872,7 @@ int gpmi_send_data(struct gpmi_nand_data *this)
>  	pio[1] = 0;
>  	desc = channel->device->device_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
> -					ARRAY_SIZE(pio), DMA_NONE, 0);
> +					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
>  	if (!desc) {
>  		pr_err("step 1 error\n");
>  		return -1;
> @@ -881,7 +881,7 @@ int gpmi_send_data(struct gpmi_nand_data *this)
>  	/* [2] send DMA request */
>  	prepare_data_dma(this, DMA_TO_DEVICE);
>  	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
> -						1, DMA_TO_DEVICE, 1);
> +						1, DMA_MEM_TO_DEV, 1);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -908,7 +908,7 @@ int gpmi_read_data(struct gpmi_nand_data *this)
>  	pio[1] = 0;
>  	desc = channel->device->device_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
> -					ARRAY_SIZE(pio), DMA_NONE, 0);
> +					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
>  	if (!desc) {
>  		pr_err("step 1 error\n");
>  		return -1;
> @@ -917,7 +917,7 @@ int gpmi_read_data(struct gpmi_nand_data *this)
>  	/* [2] : send DMA request */
>  	prepare_data_dma(this, DMA_FROM_DEVICE);
>  	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
> -						1, DMA_FROM_DEVICE, 1);
> +						1, DMA_DEV_TO_MEM, 1);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -964,7 +964,7 @@ int gpmi_send_page(struct gpmi_nand_data *this,
>  
>  	desc = channel->device->device_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
> -					ARRAY_SIZE(pio), DMA_NONE, 0);
> +					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -998,7 +998,8 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  		| BF_GPMI_CTRL0_XFER_COUNT(0);
>  	pio[1] = 0;
>  	desc = channel->device->device_prep_slave_sg(channel,
> -				(struct scatterlist *)pio, 2, DMA_NONE, 0);
> +				(struct scatterlist *)pio, 2,
> +				DMA_TRANS_NONE, 0);
>  	if (!desc) {
>  		pr_err("step 1 error\n");
>  		return -1;
> @@ -1027,7 +1028,7 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  	pio[5] = auxiliary;
>  	desc = channel->device->device_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
> -					ARRAY_SIZE(pio), DMA_NONE, 1);
> +					ARRAY_SIZE(pio), DMA_TRANS_NONE, 1);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -1045,7 +1046,8 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  		| BF_GPMI_CTRL0_XFER_COUNT(geo->page_size);
>  	pio[1] = 0;
>  	desc = channel->device->device_prep_slave_sg(channel,
> -				(struct scatterlist *)pio, 2, DMA_NONE, 1);
> +				(struct scatterlist *)pio, 2,
> +				DMA_TRANS_NONE, 1);
>  	if (!desc) {
>  		pr_err("step 3 error\n");
>  		return -1;
It's ok to me.

