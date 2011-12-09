Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1LIRTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:19:42 -0500
Received: from bay0-omc2-s7.bay0.hotmail.com ([65.54.190.82]:19210 "EHLO
	bay0-omc2-s7.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab1LIRTk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:19:40 -0500
Message-ID: <BAY163-W45C53B9E3E9E0B8629B683FBB90@phx.gbl>
X-Originating-IP: [82.43.252.147]
From: Anand Kanaginhal <anand_dk@hotmail.com>
To: <mjg59@srcf.ucam.org>
CC: <bhelgaas@google.com>, <greg@kroah.com>,
        Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: RE: PCIe Hotplugging not working
Date: Fri, 9 Dec 2011 09:19:39 -0800
Importance: Normal
In-Reply-To: <20111209124524.GA3488@srcf.ucam.org>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>,<BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>,<20111130154022.GA1411@srcf.ucam.org>,<BAY163-W80F10350D24162EFC3699FBB00@phx.gbl>,<20111130182423.GA4831@srcf.ucam.org>,<CAErSpo5SvHSJrdkWituFq11hMt=jbiobnxHeddN9Xf4DmK640g@mail.gmail.com>,<BAY163-W600D6D6A04D4BAE8278907FBB90@phx.gbl>,<20111209124524.GA3488@srcf.ucam.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Dec 2011 17:19:39.0137 (UTC) FILETIME=[BB582F10:01CCB696]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following Daring fireball :).. my comments inline----------------------------------------
> Date: Fri, 9 Dec 2011 12:45:25 +0000
> From: mjg59@srcf.ucam.org
> To: anand_dk@hotmail.com
> CC: bhelgaas@google.com; greg@kroah.com; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; linux-hotplug@vger.kernel.org
> Subject: Re: PCIe Hotplugging not working
>
> Do you have anything in /sys/class/pci/slots ? Does your card show up in
> lspci when you hotplug it?
I dont see the directory structure /sys/class/pci/slots 

$ ls /sys/class   
ata_device  dmi		 leds	   power_supply  scsi_disk	tty
ata_link    firmware	 mdio_bus  ppdev	 scsi_generic	usbmon
ata_port    gpio	 mem	   ppp		 scsi_host	vc
backlight   graphics	 misc	   printer	 sound		vtconsole
bdi	    hidraw	 mmc_host  regulator	 spi_host	wmi
block	    hwmon	 net	   rfkill	 spi_master
bsg	    i2c-adapter  pci_bus   rtc		 spi_transport
dma	    input	 pktcdvd   scsi_device	 thermaldirectories. 


However, slots was found in /sys/bus/pci/slots

$ ls /sys/bus/pci/slots
0000:00:00.0  0000:00:10.0  0000:00:1c.0  0000:00:1f.2	0000:03:01.0
0000:00:03.0  0000:00:10.1  0000:00:1c.4  0000:00:1f.3	0000:03:08.0
0000:00:08.0  0000:00:16.0  0000:00:1c.6  0000:00:1f.5	0000:03:09.0
0000:00:08.1  0000:00:19.0  0000:00:1d.0  0000:01:00.0	0000:04:00.0
0000:00:08.2  0000:00:1a.0  0000:00:1e.0  0000:01:00.1	0000:07:00.0
0000:00:08.3  0000:00:1b.0  0000:00:1f.0  0000:02:00.0	0000:08:00.0

lspci neither adds nor removes entries on hotplugging either card c1,c2.
Output of lspci is as follows 

$ lspci 
...
02:00.0 PCI bridge: PLX Technology, Inc. PEX 8533 32-lane, 6-port PCI Express Switch (rev aa)
03:01.0 PCI bridge: PLX Technology, Inc. PEX 8533 32-lane, 6-port PCI Express Switch (rev aa)
03:08.0 PCI bridge: PLX Technology, Inc. PEX 8533 32-lane, 6-port PCI Express Switch (rev aa)
03:09.0 PCI bridge: PLX Technology, Inc. PEX 8533 32-lane, 6-port PCI Express Switch (rev aa)
 
anand card c1>>>>>>>>04:00.0 Memory controller: Device 174a:0701  
anand card c2>>>>>>>>05:00.0 Ethernet controller: Agere Systems ET-131x PCI-E Ethernet Controller (rev 02) 
....
$ 
Also along the other stuffs, for the topology I am having, please let me know if my assumptions are technically correct
---
1. With the above setup, If I hotplug card c1 and/or c2, will my driver probe 
get invoked. 
2. I dont have to add any rules for in /etc/udev/rules.d/*.rules for my driver
 to work. 
3. The standard hotplug controller driver would get the hotplug event from the
 switch and handle it. 
4. The standard hotplug controller driver will be responsible for invoking 
.probe and .remove functions of my driver.
---
Thanks
Anand


>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
 		 	   		  