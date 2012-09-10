Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2IJOsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:48:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29571 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab2IJOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:48:08 -0400
Date: Mon, 10 Sep 2012 17:47:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, arnd@arndb.de, oakad@yahoo.com,
        gregkh@linuxfoundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, bp@alien8.de,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v5 1/3] drivers/mfd: Add realtek pcie card reader driver
Message-ID: <20120910144732.GK19396@mwanda>
References: <cover.1347256563.git.wei_wang@realsil.com.cn>
 <3bdd140d1927e579fd3e2d98ecf6332650f36d6f.1347256563.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bdd140d1927e579fd3e2d98ecf6332650f36d6f.1347256563.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just had a couple few style comments is all, nothing that couldn't
be fixed in a later patch.

On Mon, Sep 10, 2012 at 04:03:29PM +0800, wei_wang@realsil.com.cn wrote:
> +static int rts5209_extra_init_hw(struct rtsx_pcr *pcr)
> +{
> +	return 0;
> +}

It would be nicer if the caller checked whether this pointer was
NULL and only called it if it needed to.

> +
> +static int rts5209_optimize_phy(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_phy_register(pcr, 0x00, 0xB966);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}

static int rts5209_optimize_phy(struct rtsx_pcr *pcr)
{
	return rtsx_pci_write_phy_register(pcr, 0x00, 0xB966);
}

> +
> +static int rts5209_turn_on_led(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, 0xFD58, 0x01, 0x00);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}

Same.

> +
> +static int rts5209_turn_off_led(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, 0xFD58, 0x01, 0x01);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +

Same.

> +static int rts5209_enable_auto_blink(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, CARD_AUTO_BLINK, 0xFF, 0x0D);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +

Same.

> +static int rts5209_disable_auto_blink(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, CARD_AUTO_BLINK, 0x08, 0x00);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +

Same.

[snip ]

> +static int rts5229_extra_init_hw(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	rtsx_pci_init_cmd(pcr);
> +
> +	/* Switch LDO3318 source from DV33 to card_3v3 */
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, 0xFE78, 0x03, 0x00);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, 0xFE78, 0x03, 0x01);
> +	/* LED shine disabled, set initial shine cycle period */
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, 0xFC1E, 0x0F, 0x02);
> +
> +	err = rtsx_pci_send_cmd(pcr, 100);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;

	return rtsx_pci_send_cmd(pcr, 100);

> +}
> +
> +static int rts5229_optimize_phy(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	/* Optimize RX sensitivity */
> +	err = rtsx_pci_write_phy_register(pcr, 0x00, 0xBA42);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}

Same.

> +
> +static int rts5229_turn_on_led(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, 0xFC1F, 0x02, 0x02);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +

Same.

> +static int rts5229_turn_off_led(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, 0xFC1F, 0x02, 0x00);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}

Same.

> +
> +static int rts5229_enable_auto_blink(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, 0xFC1E, 0x08, 0x08);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}

Same.

> +
> +static int rts5229_disable_auto_blink(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, 0xFC1E, 0x08, 0x00);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}

Same.

[ snip ].

> +static DEFINE_PCI_DEVICE_TABLE(rtsx_pci_ids) = {
> +	{ 0x10EC, 0x5209, PCI_ANY_ID, PCI_ANY_ID,
> +		PCI_CLASS_OTHERS << 16, 0xFF0000 },
> +	{ 0x10EC, 0x5229, PCI_ANY_ID, PCI_ANY_ID,
> +		PCI_CLASS_OTHERS << 16, 0xFF0000 },

If you want to fit it all on one line you could do:

	{ PCI_DEVICE(0x10EC, 0x5229), PCI_CLASS_OTHERS << 16, 0xFF0000 },

It's weird that this is the only driver in the kernel which uses
the PCI_CLASS_OTHERS macro like this.

[ snip ]

> +int rtsx_pci_read_register(struct rtsx_pcr *pcr, u16 addr, u8 *data)
> +{
> +	u32 val = 2 << 30;
> +	int i;
> +
> +	val |= (u32)(addr & 0x3FFF) << 16;
> +	rtsx_pci_writel(pcr, RTSX_HAIMR, val);
> +
> +	for (i = 0; i < MAX_RW_REG_CNT; i++) {
> +		val = rtsx_pci_readl(pcr, RTSX_HAIMR);
> +		if ((val & (1 << 31)) == 0)

When we set this we do "2 << 30" but when we test it we do
"1 << 31".  It would be nice to be consistent.

> +int rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val)
> +{
> +	int err, i, finished = 0;
> +	u16 data = 0;
            ^^^^^^^^
Not needed.

> +	u8 *ptr, tmp;
> +

[ snip ]
> +	spin_lock_irqsave(&pcr->lock, flags);
> +
> +	if (pcr->trans_result == TRANS_RESULT_FAIL) {
> +		err = -EINVAL;
> +		spin_unlock_irqrestore(&pcr->lock, flags);
> +		goto out;
> +	} else if (pcr->trans_result == TRANS_NO_DEVICE) {
> +		err = -ENODEV;
> +		spin_unlock_irqrestore(&pcr->lock, flags);
> +		goto out;
> +	}
> +
> +	spin_unlock_irqrestore(&pcr->lock, flags);


Could be written like:
	if (pcr->trans_result == TRANS_RESULT_FAIL)
		err = -EINVAL;
	else if (pcr->trans_result == TRANS_NO_DEVICE)
		err = -ENODEV;

	spin_unlock_irqrestore(&pcr->lock, flags);

> +
> +out:
> +	spin_lock_irqsave(&pcr->lock, flags);
> +	pcr->done = NULL;
> +	spin_unlock_irqrestore(&pcr->lock, flags);
> +

[snip]

> +	pcr->slots = kzalloc(sizeof(struct rtsx_slot) * pcr->num_slots,
> +			GFP_KERNEL);

You could use kcalloc() here.

regards,
dan carpenter
