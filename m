Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab0D3Rqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:46:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48174 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933546Ab0D3RqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:46:00 -0400
Date: Thu, 29 Apr 2010 12:03:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/4] Mobile security processor driver
Message-ID: <20100429120321.55b90efc@lxorguk.ukuu.org.uk>
In-Reply-To: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AC@orsmsx501.amr.corp.intel.com>
References: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AC@orsmsx501.amr.corp.intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -struct sep_driver_init_t {
> -       /* start of the 1G of the host memory address that SEP can access */
> -       unsigned long message_addr;
> +  /* new base address */
> +  dma_addr_t   new_base_addr;
> +};

We seem to be going backwards - deformatting code


> +static inline u32 SEP_READ_REGISTER(struct device_context *dev, int reg)
> +{
> +       void __iomem *addr = dev->reg_addr + reg;
> +       return readl_be(addr);
> +}

Re adding wrappers


> +#define SEP_CHANGE_ENDIANNESS(val) \
> +      (((val) >> 24) | (((val) & 0x00FF0000) >> 8) | \
> +      (((val) & 0x0000FF00) << 8) | \
> +      (((val) & 0x000000FF) << 24))

And other goo


>    *  CHANGES:
>    *
> - *  2009.06.26 Initial publish
> + *  2010.01.08 Initial publish

Sorry ?????

