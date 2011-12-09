Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1LIPDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:03:50 -0500
Received: from bay0-omc2-s25.bay0.hotmail.com ([65.54.190.100]:21981 "EHLO
	bay0-omc2-s25.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849Ab1LIPDs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:03:48 -0500
Message-ID: <BAY163-W58A0B068C3EEAC0D484E8EFBB90@phx.gbl>
X-Originating-IP: [82.43.252.147]
From: Anand Kanaginhal <anand_dk@hotmail.com>
To: <mjg59@srcf.ucam.org>
CC: <bhelgaas@google.com>, <greg@kroah.com>,
        Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: RE: PCIe Hotplugging not working
Date: Fri, 9 Dec 2011 07:03:48 -0800
Importance: Normal
In-Reply-To: <20111209124524.GA3488@srcf.ucam.org>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>,<BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>,<20111130154022.GA1411@srcf.ucam.org>,<BAY163-W80F10350D24162EFC3699FBB00@phx.gbl>,<20111130182423.GA4831@srcf.ucam.org>,<CAErSpo5SvHSJrdkWituFq11hMt=jbiobnxHeddN9Xf4DmK640g@mail.gmail.com>,<BAY163-W600D6D6A04D4BAE8278907FBB90@phx.gbl>,<20111209124524.GA3488@srcf.ucam.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Dec 2011 15:03:48.0056 (UTC) FILETIME=[C0EBED80:01CCB683]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


$ ls /sys/class/pci_bus
0000:00  0000:02  0000:04  0000:06  0000:08
0000:01  0000:03  0000:05  0000:07  0000:09

The card doesn't show up in lspci after hotplugging ( or doesnt disappear when pulled out), 
However the card shows up if the card is plugged in while booting up the PC. 

Below is the lspci output when the cards are connected at booting.

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
Also wanted to know if my assumptions below are correct ?
--------------------------------------------------------------------------------
Please correct me if any of my understanding below is incorrect:
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



> Date: Fri, 9 Dec 2011 12:45:25 +0000
> From: mjg59@srcf.ucam.org
> To: anand_dk@hotmail.com
> CC: bhelgaas@google.com; greg@kroah.com; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; linux-hotplug@vger.kernel.org
> Subject: Re: PCIe Hotplugging not working
> 
> Do you have anything in /sys/class/pci/slots ? Does your card show up in 
> lspci when you hotplug it?
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
 		 	   		  