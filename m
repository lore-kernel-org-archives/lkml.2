Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab1ALF1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:27:18 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:12927 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab1ALF1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:27:16 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Milton Miller'" <miltonm@bga.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <yong.y.wang@intel.com>,
        <joel.clark@intel.com>, <kok.howg.ewe@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>,
        "'Wang, Qi'" <qi.wang@intel.com>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com><20101229064937.GC8172@angua.secretlab.ca><280596192AA74D208C2C5F6389DBE8C1@hacdom.okisemi.com><20110105163835.GD17272@angua.secretlab.ca><46862922F48B45F781832619CF3F4B79@hacdom.okisemi.com> <topcliff-split@mdm.bga.com>  <CA1F4AF27C0D466BA059E4B050FF3360@hacdom.okisemi.com>
Subject: RE: [PATCH 1/3] spi_topcliff_pch: support new device ML7213
Date: Wed, 12 Jan 2011 14:27:12 +0900
Message-ID: <A780EBC01B4946F895EA47BE425B56F8@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <CA1F4AF27C0D466BA059E4B050FF3360@hacdom.okisemi.com>
Thread-Index: AcuuTF63DADl1Jf1TeW6DYK5JWPNRgDJS+zAAAB3ltAAKPoKsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 11, 2011 6:42 PM, Tomoya MORINAGA wrote:
> However, I couldn't clear my question.

I show the current our coding image.
Is the following agreeable with your saying ?

struct spi_platform_data {
	u16 num_chipselect;
	bool little_endian;
	u8 bits_per_word;
	struct spi_board_info *devices;
	u8 num_devices;
};

static struct resource pch_spi_resources[] = {
	{
		.start 	= 0,
		.end	= 0,
		.flags	= IORESOURCE_MEM,
	},
	{
		.start	= 0,
		.end	= 0,
		.flags	= IORESOURCE_IRQ,
	},
};

static struct spi_platform_data pch_spi_platform_data = {
	.num_chipselect = 2,
	.little_endian = true,
};

static struct pch_spi_cell pch_spi_cfg0 = {
	.name = "pch_spi",
	.num_resources = ARRAY_SIZE(pch_spi_resources),
	.resources = pch_spi_resources,
	.platform_data = &pch_spi_platform_data,
	.data_size = sizeof(pch_spi_platform_data),
};

static int pch_spi_get_resources(struct pch_spi_board_data *board_dat, int num)
{
	int retval;
	int i;

	/* create workqueue */
	board_dat->data[num]->wk = create_singlethread_workqueue(KBUILD_MODNAME);

	pci_request_regions(board_dat->pdev, KBUILD_MODNAME);
}

static int pch_spi_add_device(struct device *parent, int id,
			  struct pch_spi_cell *cell,
			  struct resource *mem_base, int irq_base,
			      struct pch_spi_board_data *board_dat)
{

	platform_device_alloc(cell->name, id + cell->id);

	res = kzalloc(sizeof(*res) * cell->num_resources, GFP_KERNEL);
	if (!res)
		goto fail_device;

	platform_set_drvdata(pdev, cell->driver_data);

	if (cell->data_size) {
		platform_device_add_data(pdev,
					cell->platform_data, cell->data_size);
	}

	for (i = 0; i < cell->num_resources; i++) {
		if ((cell->resources[i].flags & IORESOURCE_MEM) && mem_base) {
			res[i].parent = 
			res[i].start = 
			res[i].end = 
		} else if (cell->resources[i].flags & IORESOURCE_IRQ) {
			res[i].start = 
			res[i].end   = 
		} else {


	}

	ret = platform_device_add_resources(pdev, res, cell->num_resources);
	if (ret)
		goto fail_res;

	ret = platform_device_add(pdev);
	if (ret)
		goto fail_res;

	kfree(res);

	spi_alloc_master( );

	board_dat->data[num] = spi_master_get_devdata( );

	pch_spi_get_resources( );

	/* set master mode */
	pch_spi_set_master_mode( );

	/* Register the controller with the SPI core. */
	spi_register_master( );

	return 0;
}

int pch_spi_add_devices(struct device *parent,
		    struct pch_spi_cell *cells, int n_devs,
		    struct resource *mem_base,
		    struct pch_spi_board_data *board_dat)
{
	pci_iomap()

	for (i < n_devs)
		pch_spi_add_device()

}

static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
{
	board_dat = kzalloc(sizeof(struct pch_spi_board_data), GFP_KERNEL);
	pci_enable_device()
	request_irq()
	pch_spi_add_devices(&pdev->dev, 
			&pch_spi_cfg0,
			2,
			&pdev->resource[0], board_dat);

}

static irqreturn_t pch_spi_handler(int irq, void *dev_id)
{

	for (i = 0; i < board_dat->num; i++) {
		data = board_dat->data[i];
		io_remap_addr = data->io_remap_addr;
		spsr = io_remap_addr + PCH_SPSR;

		reg_spsr_val = ioread32(spsr);

		/* Check if the interrupt is for SPI device */
		if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
			pch_spi_handler_sub(data, reg_spsr_val, io_remap_addr);
			ret = IRQ_HANDLED;
		}

		dev_dbg(&board_dat->pdev->dev, "%s EXIT return value=%d\n",
			__func__, ret);
	}
	return ret;
}

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

