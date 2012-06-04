Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2FDPxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:53:05 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43502 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab2FDPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:53:03 -0400
Date: Mon, 4 Jun 2012 16:56:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Alessandro Rubini <rubini@gnudd.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Message-ID: <20120604165619.15ba43bf@pyramind.ukuu.org.uk>
In-Reply-To: <1338816766-7089-2-git-send-email-federico.vaga@gmail.com>
References: <4FC135C6.5030206@grandegger.com>
	<1338816766-7089-1-git-send-email-federico.vaga@gmail.com>
	<1338816766-7089-2-git-send-email-federico.vaga@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +enum c_can_pci_reg_align {
> +	C_CAN_REG_ALIGN_16,
> +	C_CAN_REG_ALIGN_32,
> +};

Anythign wrong with 

bool aligned32;

> +
> +struct c_can_pci_data {
> +	unsigned int reg_align;	/* Set the register alignment in the memory */

Not the enum .. indeed

> +static u16 c_can_pci_read_reg_aligned_to_16bit(struct c_can_priv *priv,
> +						void *reg)

I'm a bit worried this function name might be too short ;)


> +	dev_info(&pdev->dev, "%s device registered (regs=%p, irq=%d)\n",
> +		 KBUILD_MODNAME, priv->regs, dev->irq);

dev_dbg

> +	 * do not call pci_disable_device on sta2x11 because it
> +	 * break all other Bus masters on this EP
> +	 */
> +	if(pdev->vendor == PCI_VENDOR_ID_STMICRO &&
> +	   pdev->device == PCI_DEVICE_ID_STMICRO_CAN)
> +		goto out;

Is that the disabling or the dropping it into D3. We have a PCI quirk
flag for the latter. See "quirk_no_ata_d3". That will also avoid any
accidents elsewhere. Right now the quirk has "ata" in the name but the
ata is just historically because we had to quirk various disk controllers.


