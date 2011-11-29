Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1K2P0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:26:31 -0500
Received: from smtp-out-2.desy.de ([131.169.56.85]:48799 "EHLO
	smtp-out-2.desy.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1K2P03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:26:29 -0500
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Nov 2011 10:26:29 EST
Message-ID: <4ED4F798.9020106@desy.de>
Date: Tue, 29 Nov 2011 16:17:44 +0100
From: Ludvig Petrossian <lyudvig.petrosyan@desy.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Anand Kanaginhal <anand_dk@hotmail.com>
CC: Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: Re: PCIe Hotplugging not working
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl> <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>
In-Reply-To: <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/11/11 12:56, Anand Kanaginhal wrote:
>
> I am trying to get PCIe endpoint hot - plugging working
>
> The Set up is such that there is one endpoint (our custom device) connected to PCI  switch PLX 8609 8 port 8 lane switch. 
> 1. I have my driver module compiled, copied into /lib/modules/`uname -r`/kernel/drivers/char/
> 2. I run depmod and "modules.pcimap" also got updated with my module. 
>
> However
>  if I unplug and plug in the endpoint, my driver .probe and .remove functions
>  are not being invoked. Is there something more to be done at the bus 
> level to get the driver to hot plug ?
>
> I have tried various kernel version, Currently I am trying on 2.6.38.12 (UBUNTU flavor).
> First is there anything missing ? Also Please give me some pointers and debug direction.
>
> Thanks
> Anand
>
>  		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi Anand

Did You enable the pcie hotplug driver (pciehp)
One can do it adding the next options to the /boot/grub/menu.lst
pciehp.pciehp_force=1 pciehp.pciehp_debug=1
(example of my menu.lst: kernel        /boot/vmlinuz-2.6.32-28-generic
root=UUID=330631e1-99a3-46d3-bf52-f4ca23c6b6ef ro pciehp.pciehp_force=1
pciehp.pciehp_debug=1 acpi=off noapic console=tty0 console=ttyS0 quiet )

so You can see the pciehp outputs in /var/log/kern.log

regards

Ludwig
