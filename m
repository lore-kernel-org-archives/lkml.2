Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab2FYVam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 17:30:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62895 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab2FYVak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 17:30:40 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org,
        "Alexandre Pereira da Silva" <aletes.xgr@gmail.com>
Subject: Re: [RFC 2/2] usb: gadget: composite: parse dt overrides
References: <1340655832-30447-1-git-send-email-aletes.xgr@gmail.com>
Date: Mon, 25 Jun 2012 23:30:36 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wgg91aya3l0zgt@mpn-glaptop>
In-Reply-To: <1340655832-30447-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Opera Mail/12.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012 22:23:52 +0200, Alexandre Pereira da Silva <aletes.xgr@gmail.com> wrote:
> Grab the devicetree node properties to override VendorId, ProductId,
> bcdDevice, Manucacturer, Product and SerialNumber
>
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> @@ -1470,6 +1472,35 @@ static int composite_bind(struct usb_gadget *gadget)
> 	cdev->desc = *composite->dev;
>+	/* grab overrides from devicetree */
> +	if (np) {
> +		u32 reg;
> +
> +		if (!idVendor &&
> +			of_property_read_u32(np, "vendor_id", &reg) == 0)
> +			idVendor = reg;
> +
> +		if (!idProduct &&
> +			of_property_read_u32(np, "product_id", &reg) == 0)
> +			idProduct = reg;
> +
> +		if (!bcdDevice &&
> +			of_property_read_u32(np, "bcd_device", &reg) == 0)
> +			bcdDevice = reg;
> +
> +		if (!iManufacturer)
> +			of_property_read_string(np, "manufacturer",
> +				&iManufacturer);
> +
> +		if (!iProduct)
> +			of_property_read_string(np, "product",
> +				&iProduct);
> +
> +		if (!iSerialNumber)
> +			of_property_read_string(np, "serial_number",
> +				&iSerialNumber);
> +	}
> +
>  	/* standardized runtime overrides for device ID data */
>  	if (idVendor)
>  		cdev->desc.idVendor = cpu_to_le16(idVendor);


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
