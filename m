Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1BVNfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:35:00 -0500
Received: from mail.solarflare.com ([216.237.3.220]:4068 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1BVNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:34:59 -0500
Subject: Re: [PATCH] rt2x00: Use ops name instead of device name
From: Ben Hutchings <bhutchings@solarflare.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>, abogani@texware.it
In-Reply-To: <1298380368.6140.1193.camel@gandalf.stny.rr.com>
References: <1298380368.6140.1193.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 22 Feb 2011 13:34:55 +0000
Message-ID: <1298381695.2211.486.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Feb 2011 13:34:59.0023 (UTC) FILETIME=[4CC685F0:01CBD295]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17970.004
X-TM-AS-Result: No--15.032200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 08:12 -0500, Steven Rostedt wrote:
> Recently, someone complained that they see the PCI address of a device
> in the interrupts file instead of the device name.
> 
> 19:   73474106          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb6, 0000:05:01.0
[...]
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index ace0b66..06575dc 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -284,7 +284,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>  	rt2x00dev->ops = ops;
>  	rt2x00dev->hw = hw;
>  	rt2x00dev->irq = pci_dev->irq;
> -	rt2x00dev->name = pci_name(pci_dev);
> +	rt2x00dev->name = ops->name;
>  
>  	if (pci_is_pcie(pci_dev))
>  		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);

But then how can users distinguish the IRQs for multiple devices handled
by the same driver?  (Probably unusual for WLAN devices, but still
possible.)

I assume you can't use a net device name as there may be multiple net
devices per bus device?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

