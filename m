Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab1ASG0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:26:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36374 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1ASG0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:26:03 -0500
Date: Tue, 18 Jan 2011 23:25:58 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: "'Milton Miller'" <miltonm@bga.com>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>,
        "'Wang, Qi'" <qi.wang@intel.com>
Subject: Re: [PATCH 1/3] spi_topcliff_pch: support new device ML7213
Message-ID: <20110119062558.GD2545@angua.secretlab.ca>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <20101229064937.GC8172@angua.secretlab.ca>
 <280596192AA74D208C2C5F6389DBE8C1@hacdom.okisemi.com>
 <20110105163835.GD17272@angua.secretlab.ca>
 <46862922F48B45F781832619CF3F4B79@hacdom.okisemi.com>
 <topcliff-split@mdm.bga.com>
 <CA1F4AF27C0D466BA059E4B050FF3360@hacdom.okisemi.com>
 <A780EBC01B4946F895EA47BE425B56F8@hacdom.okisemi.com>
 <EEE6F4C641AC4593B5CDF5139FCAD0F6@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EEE6F4C641AC4593B5CDF5139FCAD0F6@hacdom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 09:36:48PM +0900, Tomoya MORINAGA wrote:
> Hi Grant,
> 
> Need your help!
> Could you give us your answer ?

Hi Tomoya, I've not forgotten about you, just a little swamped with
other stuff.  I'll try to get you a proper reply tomorrow.

g.

> 
> Thanks,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 
> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org 
> > [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
> > Tomoya MORINAGA
> > Sent: Wednesday, January 12, 2011 2:27 PM
> > To: 'Milton Miller'; 'Grant Likely'
> > Cc: 'David Brownell'; 
> > spi-devel-general@lists.sourceforge.net; 
> > linux-kernel@vger.kernel.org; yong.y.wang@intel.com; 
> > joel.clark@intel.com; kok.howg.ewe@intel.com; 'Toshiharu 
> > Okada'; 'Wang, Qi'
> > Subject: RE: [PATCH 1/3] spi_topcliff_pch: support new device ML7213
> > 
> > On Tuesday, January 11, 2011 6:42 PM, Tomoya MORINAGA wrote:
> > > However, I couldn't clear my question.
> > 
> > I show the current our coding image.
> > Is the following agreeable with your saying ?
> > 
> > struct spi_platform_data {
> > 	u16 num_chipselect;
> > 	bool little_endian;
> > 	u8 bits_per_word;
> > 	struct spi_board_info *devices;
> > 	u8 num_devices;
> > };
> > 
> > static struct resource pch_spi_resources[] = {
> > 	{
> > 		.start 	= 0,
> > 		.end	= 0,
> > 		.flags	= IORESOURCE_MEM,
> > 	},
> > 	{
> > 		.start	= 0,
> > 		.end	= 0,
> > 		.flags	= IORESOURCE_IRQ,
> > 	},
> > };
> > 
> > static struct spi_platform_data pch_spi_platform_data = {
> > 	.num_chipselect = 2,
> > 	.little_endian = true,
> > };
> > 
> > static struct pch_spi_cell pch_spi_cfg0 = {
> > 	.name = "pch_spi",
> > 	.num_resources = ARRAY_SIZE(pch_spi_resources),
> > 	.resources = pch_spi_resources,
> > 	.platform_data = &pch_spi_platform_data,
> > 	.data_size = sizeof(pch_spi_platform_data), };
> > 
> > static int pch_spi_get_resources(struct pch_spi_board_data 
> > *board_dat, int num) {
> > 	int retval;
> > 	int i;
> > 
> > 	/* create workqueue */
> > 	board_dat->data[num]->wk = 
> > create_singlethread_workqueue(KBUILD_MODNAME);
> > 
> > 	pci_request_regions(board_dat->pdev, KBUILD_MODNAME); }
> > 
> > static int pch_spi_add_device(struct device *parent, int id,
> > 			  struct pch_spi_cell *cell,
> > 			  struct resource *mem_base, int irq_base,
> > 			      struct pch_spi_board_data *board_dat) {
> > 
> > 	platform_device_alloc(cell->name, id + cell->id);
> > 
> > 	res = kzalloc(sizeof(*res) * cell->num_resources, GFP_KERNEL);
> > 	if (!res)
> > 		goto fail_device;
> > 
> > 	platform_set_drvdata(pdev, cell->driver_data);
> > 
> > 	if (cell->data_size) {
> > 		platform_device_add_data(pdev,
> > 					cell->platform_data, 
> > cell->data_size);
> > 	}
> > 
> > 	for (i = 0; i < cell->num_resources; i++) {
> > 		if ((cell->resources[i].flags & IORESOURCE_MEM) 
> > && mem_base) {
> > 			res[i].parent = 
> > 			res[i].start = 
> > 			res[i].end = 
> > 		} else if (cell->resources[i].flags & IORESOURCE_IRQ) {
> > 			res[i].start = 
> > 			res[i].end   = 
> > 		} else {
> > 
> > 
> > 	}
> > 
> > 	ret = platform_device_add_resources(pdev, res, 
> > cell->num_resources);
> > 	if (ret)
> > 		goto fail_res;
> > 
> > 	ret = platform_device_add(pdev);
> > 	if (ret)
> > 		goto fail_res;
> > 
> > 	kfree(res);
> > 
> > 	spi_alloc_master( );
> > 
> > 	board_dat->data[num] = spi_master_get_devdata( );
> > 
> > 	pch_spi_get_resources( );
> > 
> > 	/* set master mode */
> > 	pch_spi_set_master_mode( );
> > 
> > 	/* Register the controller with the SPI core. */
> > 	spi_register_master( );
> > 
> > 	return 0;
> > }
> > 
> > int pch_spi_add_devices(struct device *parent,
> > 		    struct pch_spi_cell *cells, int n_devs,
> > 		    struct resource *mem_base,
> > 		    struct pch_spi_board_data *board_dat) {
> > 	pci_iomap()
> > 
> > 	for (i < n_devs)
> > 		pch_spi_add_device()
> > 
> > }
> > 
> > static int pch_spi_probe(struct pci_dev *pdev, const struct 
> > pci_device_id *id) {
> > 	board_dat = kzalloc(sizeof(struct pch_spi_board_data), 
> > GFP_KERNEL);
> > 	pci_enable_device()
> > 	request_irq()
> > 	pch_spi_add_devices(&pdev->dev, 
> > 			&pch_spi_cfg0,
> > 			2,
> > 			&pdev->resource[0], board_dat);
> > 
> > }
> > 
> > static irqreturn_t pch_spi_handler(int irq, void *dev_id) {
> > 
> > 	for (i = 0; i < board_dat->num; i++) {
> > 		data = board_dat->data[i];
> > 		io_remap_addr = data->io_remap_addr;
> > 		spsr = io_remap_addr + PCH_SPSR;
> > 
> > 		reg_spsr_val = ioread32(spsr);
> > 
> > 		/* Check if the interrupt is for SPI device */
> > 		if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
> > 			pch_spi_handler_sub(data, reg_spsr_val, 
> > io_remap_addr);
> > 			ret = IRQ_HANDLED;
> > 		}
> > 
> > 		dev_dbg(&board_dat->pdev->dev, "%s EXIT return 
> > value=%d\n",
> > 			__func__, ret);
> > 	}
> > 	return ret;
> > }
> > 
> > Thanks,
> > -----------------------------------------
> > Tomoya MORINAGA
> > OKI SEMICONDUCTOR CO., LTD.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-kernel" in the body of a message to 
> > majordomo@vger.kernel.org More majordomo info at  
> > http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
