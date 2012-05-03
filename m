Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2ECMhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:37:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57417 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2ECMhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:37:53 -0400
Date: Thu, 3 May 2012 13:40:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rsarmah@apm.com
Subject: Re: [PATCH v16 03/10]USB/ppc4xx: Add Synopsys DWC OTG Core
 Interface Layer (CIL)
Message-ID: <20120503134029.7195898d@pyramind.ukuu.org.uk>
In-Reply-To: <201205031228.q43CSw6k024808@amcc.com>
References: <201205031228.q43CSw6k024808@amcc.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> +void dwc_otg_flush_rx_fifo(struct core_if *core_if)
> +{
> +	ulong global_regs = core_if->core_global_regs;


These are all a bit odd. The register has a given size so they ought to
be u32 or u64 etc as appropriate for the register in question, ditto the
cache in the structure.



> +	for (i = 0; i < MAX_EPS_CHANNELS; i++) {
> +		offset = i * DWC_EP_REG_OFFSET;
> +
> +		dev_if->in_ep_regs[i] = (ulong)(reg_base +
> +					       DWC_DEV_IN_EP_REG_OFFSET +
> +					       offset);

And again some of the casting seems odd. If these are bus addresses they
should be typed as such.


> +static inline u32 dwc_reg_read(ulong reg , u32 offset)
> +{
> +
> +#ifdef CONFIG_DWC_OTG_REG_LE
> +	return in_le32((void __iomem *)(reg + offset));
> +#else
> +	return in_be32((void __iomem *)(reg + offset));

All this casting is a symptom of the same typing problems. They would all
go away if the types were right in the first place.

> +	u32 global_regs = (u32) core_if->core_global_regs;

And again we keep finding these casts caused by wrong types


