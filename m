Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab2HAXYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:24:06 -0400
Received: from foo.stuge.se ([212.116.89.98]:42210 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753498Ab2HAXYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:24:04 -0400
Message-ID: <20120801232358.30215.qmail@stuge.se>
Date: Thu, 2 Aug 2012 01:23:58 +0200
From: Peter Stuge <peter@stuge.se>
To: "Alexis R. Cortes" <alexis.cortes@ti.com>
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        brian.quach@ti.com, jorge.llamas@ti.com
Subject: Re: [PATCH] usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP
	Hardware
Mail-Followup-To: "Alexis R. Cortes" <alexis.cortes@ti.com>,
	sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	brian.quach@ti.com, jorge.llamas@ti.com
References: <5019AF84.7020404@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5019AF84.7020404@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexis R. Cortes wrote:
> This patch is intended to work around a known issue on the
> SN65LVPE502CP USB3.0 re-driver that can delay the negotiation
> between a device and the host past the usual handshake timeout,
> and if that happens on the first insertion, the host controller
> port will enter in Compliance Mode as per xHCI Spec, thus causing
> the port to become Unusable. This patch creates a timer which polls
> every 2 seconds the link state of each host controller's port (this
> by reading the PORTSC register) and recovers the port by issuing a
> Warm reset every time Compliance mode is detected. Since the issue
> is being caused by a pice of hardware, the timer will be enabled

Typo, insert an 'e' here ^


> +++ b/drivers/usb/host/xhci.c
..
> @@ -420,6 +477,12 @@ int xhci_init(struct usb_hcd *hcd)
>  	retval = xhci_mem_init(xhci, GFP_KERNEL);
>  	xhci_dbg(xhci, "Finished xhci_init\n");
>  
> +	/* Initializing Compliance Mode Recovery Data If Needed */
> +	if (compliance_mode_recovery_timer_quirk_check()) {
> +		xhci->quirks |= XHCI_COMP_MODE_QUIRK;
> +		compliance_mode_recovery_timer_init(xhci);
> +	}
> +
>  	return retval;
>  }

Maybe add the code just *before* the "Finished" debug message rather
than after.


//Peter
