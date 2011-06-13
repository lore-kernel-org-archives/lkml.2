Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1FMVmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:42:18 -0400
Received: from mail.perches.com ([173.55.12.10]:2860 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1FMVmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:42:16 -0400
Subject: Re: [PATCH 1/3] usbip: only dump valid port status
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@hinterhof.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4DF68151.4080109@freemail.hu>
References: <4DF68151.4080109@freemail.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 14:42:14 -0700
Message-ID: <1308001334.26699.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 23:29 +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The wIndex parameter of vhci_hub_control() is always zero when the
> request type is GetHubDescriptor,
> ---
> diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
> @@ -464,8 +464,11 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
> 
>  	if (usbip_dbg_flag_vhci_rh) {
>  		pr_debug("port %d\n", rhport);
> -		dump_port_status(prev_port_status[rhport]);
> -		dump_port_status(dum->port_status[rhport]);
> +		/* Only dump valid port status */
> +		if (0 <= rhport) {
> +			dump_port_status(prev_port_status[rhport]);
> +			dump_port_status(dum->port_status[rhport]);
> +		}
>  	}
>  	usbip_dbg_vhci_rh(" bye\n");
> 

Linux relatively rarely uses constant before variable in a comparison.
ie: please use "if (rhport > 0)" instead


