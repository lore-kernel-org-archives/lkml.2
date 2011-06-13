Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1FMWXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:23:54 -0400
Received: from mail.perches.com ([173.55.12.10]:2877 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098Ab1FMWXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:23:50 -0400
Subject: Re: [PATCH 1/3] usbip: only dump valid port status
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: devel@driverdev.osuosl.org, usbip-devel@lists.sourceforge.net,
        Matt Mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
In-Reply-To: <4DF6857B.3050206@freemail.hu>
References: <4DF68151.4080109@freemail.hu>
	 <1308001334.26699.18.camel@Joe-Laptop>  <4DF6857B.3050206@freemail.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 15:23:48 -0700
Message-ID: <1308003828.26699.45.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 23:47 +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The wIndex parameter of vhci_hub_control() is always zero when the
> request type is GetHubDescriptor, see drivers/usb/core/hub.c::get_hub_descriptor()
> and Universal Serial Bus Specification revision 2.0 (April 27, 2000) Section
> 11.24.2.5 "Get Hub Descriptor". This means the variable rhport will not contain
> any useful index. Only use valid rhport values.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
>  drivers/staging/usbip/vhci_hcd.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
> index 359b464..512a97f 100644
> --- a/drivers/staging/usbip/vhci_hcd.c
> +++ b/drivers/staging/usbip/vhci_hcd.c
> @@ -464,8 +464,11 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
> 
>  	if (usbip_dbg_flag_vhci_rh) {
>  		pr_debug("port %d\n", rhport);
> -		dump_port_status(prev_port_status[rhport]);
> -		dump_port_status(dum->port_status[rhport]);
> +		/* Only dump valid port status */
> +		if (rhport >= 0) {
> +			dump_port_status(prev_port_status[rhport]);
> +			dump_port_status(dum->port_status[rhport]);
> +		}

Umm, you mean to use "rhport > 0" yes?


