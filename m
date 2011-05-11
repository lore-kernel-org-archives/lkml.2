Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab1EKQOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:14:25 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:56126 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757203Ab1EKQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:14:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=I6ceHz3IZxk5ndEyFlyfBPXjE8L1gHJfKXMeoxkMLBsSX2rP53lGFo+gBUIzj59z5VISAKfQIJ6gWnsF3EocZBZAhcnHEPRf+rXSLe1lZjFSlEbm3cJ/+UKlJ3IOLML5;
Date: Wed, 11 May 2011 09:14:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH] acpiphp: assume device is in state D0 after powering on
 a slot.
Message-ID: <20110511091405.1266a34e@jbarnes-desktop>
In-Reply-To: <1305129632-2646-1-git-send-email-ian.campbell@citrix.com>
References: <20110511084354.49eee757@jbarnes-desktop>
	<1305129632-2646-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 17:00:32 +0100
Ian Campbell <ian.campbell@citrix.com> wrote:

> Devices which do not support PCI configuration space based power
> management may not otherwise be enabled.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 2f67e9b..a70fa89 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -827,6 +827,13 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>  	acpiphp_set_hpp_values(bus);
>  	acpiphp_set_acpi_region(slot);
>  	pci_enable_bridges(bus);
> +
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		/* Assume that newly added devices are powered on already. */
> +		if (!dev->is_added)
> +			dev->current_state = PCI_D0;
> +	}
> +
>  	pci_bus_add_devices(bus);
>  
>  	list_for_each_entry(func, &slot->funcs, sibling) {

applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
