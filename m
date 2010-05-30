Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab0E3N7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 09:59:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34358 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752983Ab0E3N7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 09:59:39 -0400
Date: Sun, 30 May 2010 15:07:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exclude DAHDI devices from being probed by netjet
Message-ID: <20100530150737.52bc342a@lxorguk.ukuu.org.uk>
In-Reply-To: <20100529232946.GA1748@xorcom.com>
References: <20100529232946.GA1748@xorcom.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2. I don't have more precise data than the PCI ID tables in the drivers.
>    Does this run the risk of excluding some actual Netjet ISDN cards?

Is there a reason you are seeing so many different vendor values - surely
you should see a single 'Digium' subvendor, and various subdevice values ?


> +	switch (pdev->subsystem_vendor) {
> +	/* Fall-through */
> +	case 0x2151: /* Yeastart YSTDM8xx (ystdm8xx) */
> +	case 0xe16b: /* Zapata Project PCI-Radio (pciradio) */
> +	case 0x6159: /* Digium Wildcard T100/E100 (wct1xxp) */
> +	case 0x71fe: /* Digium Wildcard TE110P (wcte1xp) */
> +	case 0x795e: /* Digium Wildcard TE110P (wcte1xp) */
> +	case 0x797e: /* Digium Wildcard TE110P (wcte1xp) */
> +	case 0x79de: /* Digium Wildcard TE110P (wcte1xp) */
> +	case 0x79df: /* Digium Wildcard TE110P (wcte1xp) */
> +	case 0x8084: /* Digium Wildcard X101P clone (wcfxo) */
> +	case 0x8085: /* Digium Wildcard X101P (wcfxo) */
> +	case 0x8086: /* Digium Wildcard X101P clone (wcfxo) */
> +	case 0x8087: /* Digium Wildcard X101P clone (wcfxo) */
> +	case 0xa800: /* Digium Wildcard TDM400P Rev H (wctdm) */
> +	case 0xa801: /* Digium Wildcard TDM400P Rev H (wctdm) */
> +	case 0xa8fd: /* Digium Wildcard TDM400P Rev H (wctdm) */
> +	case 0xa901: /* Digium Wildcard TDM400P Rev H (wctdm) */
> +	case 0xa908: /* Digium Wildcard TDM400P Rev H (wctdm) */
> +	case 0xa9fd: /* Digium Wildcard TDM400P Rev H (wctdm) */
> +	case 0xb100: /* Digium Wildcard TDM400P Rev E/F (wctdm) */
> +	case 0xb118: /* Digium Wildcard TDM400P Rev I (wctdm) */
> +	case 0xb119: /* Digium Wildcard TDM400P Rev I (wctdm) */
> +	case 0xb1d9: /* Digium Wildcard TDM400P Rev I (wctdm) */
> +	case 0xa159: /* Digium Wildcard S400P Prototype (wctdm) */
> +	case 0xe159: /* Digium Wildcard S400P Prototype (wctdm) */

That might be better as a table. You can then als include the name and
match details in the report which will help diagnose problems with it eg

	struct whatever {
		u16 svid, sdid;
		const char *name;
	}

And then print

	netjet: %s card is not supported by this driver (%04X, %04X).\n", 
		name, svid, sdid

		
Then again we don't seem to have a driver for these other kernel devices
so perhaps the safe default would be to warn and continue unless a module
option is set. At least initially.

Alan
