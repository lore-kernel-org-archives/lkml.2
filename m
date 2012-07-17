Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab2GQMWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:22:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33781 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2GQMVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:21:38 -0400
Message-ID: <500558A0.6050609@mvista.com>
Date: Tue, 17 Jul 2012 16:20:48 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Denis Turischev <denis@compulab.co.il>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] xhci: EHCI/xHCI ports switching on Intense-PC.
References: <5004454E.9030903@compulab.co.il>
In-Reply-To: <5004454E.9030903@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-07-2012 20:46, Denis Turischev wrote:

> Intense-PC is Compulab's mini-desktop with Intel Panther Point
> chipset.

> Unconditional ports switching provided by function
> usb_enable_xhci_ports() leads to surprising results, after shutdown
> system powered-on again after a few seconds. On Windows power
> related problems were not observed.

> The patch avoids ports switching for Intense-PC.

> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> ---
>   drivers/usb/host/pci-quirks.c |    7 +++++++
>   1 file changed, 7 insertions(+)

> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index df0828c..6f72593 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -759,6 +759,13 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
>   {
>   	u32		ports_available;
>
> +	const char *brd_name;

    Group this declaration with the above one please.

> +	brd_name = dmi_get_system_info(DMI_BOARD_NAME);

    Could be an initializer...

WBR, Sergei
