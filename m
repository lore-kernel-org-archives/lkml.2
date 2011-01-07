Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1AGOHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:07:23 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:55006 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab1AGOHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:07:21 -0500
Message-ID: <4D271E0E.8050401@ti.com>
Date: Fri, 07 Jan 2011 19:37:10 +0530
From: Anand Gadiyar <gadiyar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Benoit Cousson <b-cousson@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
References: <20101223171859.f6842045.sfr@canb.auug.org.au>	<4D139517.3010608@ti.com>	<AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com>	<4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com>	<AANLkTimA5UOVn6+xe0ofV1F3_XhAP0daBvOAX2k1u_dU@mail.gmail.com> <AANLkTimzQ1PHN986fqPF0yjd1M+390nSUDYJ65pu0z_f@mail.gmail.com>
In-Reply-To: <AANLkTimzQ1PHN986fqPF0yjd1M+390nSUDYJ65pu0z_f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2011 9:20 PM, Ming Lei wrote:
> Hi,
> 
> 2011/1/6 Ming Lei <tom.leiming@gmail.com>:
>> Hi,
>>
>> 2011/1/6 Anand Gadiyar <gadiyar@ti.com>:
>>
>>> I'll take a look in a short while. I don't have an XM to
>>> test, so you'll have to help me out here.
>>
>> No problem for me, :-)
> 
> I see why the beagle xM does not work, the attachment patch is
> needed to make it working.
> 
> But the ehci on panda(omap4430) still does not work with
> 2.6.37-next-20110106+, and follows the failure messages:
> 
> [   46.572601] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [   46.580017] ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
> [   46.580078] bus: 'platform': add driver ehci-omap
> [   46.580139] bus: 'platform': driver_probe_device: matched device ehci-omap.0 with driver ehci-omap
> [   46.580169] bus: 'platform': really_probe: probing driver ehci-omap with device ehci-omap.0
> [   46.580200] ehci-omap ehci-omap.0: failed to get ehci port0 regulator
> [   46.580200] ehci-omap ehci-omap.0: starting TI EHCI USB Controller
> [   46.580291] ehci-omap ehci-omap.0: OMAP UHH_REVISION 0x50700100
> [   46.580352] ehci-omap ehci-omap.0: TLL RESET DONE
> [   46.580352] ehci-omap ehci-omap.0: UHH setup done, uhh_hostconfig=1c
> [   46.580383] ehci-omap ehci-omap.0: reset hcs_params 0x1313 dbg=0 cc=1 pcc=3 ordered ports=3
> [   46.580383] ehci-omap ehci-omap.0: reset hcc_params 20016 thresh 1 uframes 256/512/1024 park LPM
> [   46.580383] ehci-omap ehci-omap.0: OMAP-EHCI Host Controller
> [   46.588592] drivers/usb/core/inode.c: creating file 'devices'
> [   46.588623] drivers/usb/core/inode.c: creating file '001'
> [   46.588684] device: 'usbmon1': device_add
> [   46.588867] PM: Adding info for No Bus:usbmon1
> [   46.590026] ehci-omap ehci-omap.0: new USB bus registered, assigned bus number 1
> [   46.645721] ehci-omap ehci-omap.0: park 0
> [   46.645721] ehci-omap ehci-omap.0: support lpm
> [   46.645751] ehci-omap ehci-omap.0: irq 109, io mem 0x4a064c00
> [   46.651763] ehci-omap ehci-omap.0: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
> [   46.651763] ehci-omap ehci-omap.0: init command 0010005 (park)=0 ithresh=1 period=512 RUN
> [   46.661254] ehci-omap ehci-omap.0: USB 2.0 started, EHCI 1.00
> [   46.667297] usb usb1: rpm_resume flags 0x0
> [   46.667297] usb usb1: rpm_resume returns 1
> [   46.667358] usb usb1: default language 0x0409
> [   46.667358] usb usb1: udev 1, busnum 1, minor = 0
> [   46.667388] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [   46.675476] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   46.683288] usb usb1: Product: OMAP-EHCI Host Controller
> [   46.689086] usb usb1: Manufacturer: Linux 2.6.37-next-20110106+ ehci_hcd
> [   46.696350] usb usb1: SerialNumber: ehci-omap.0
> [   46.701354] device: 'usb1': device_add
> [   46.701568] bus: 'usb': add device usb1
> [   46.701629] PM: Adding info for usb:usb1
> [   46.702758] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
> [   46.702758] bus: 'usb': really_probe: probing driver usb with device usb1
> [   46.702819] usb usb1: usb_probe_device
> [   46.702819] usb usb1: configuration #1 chosen from 1 choice
> [   46.702850] usb usb1: rpm_resume flags 0x4
> [   46.702850] usb usb1: rpm_resume returns 1
> [   46.702911] usb usb1: adding 1-0:1.0 (config #1, interface 0)
> [   46.702911] device: '1-0:1.0': device_add
> [   46.702941] bus: 'usb': add device 1-0:1.0
> [   46.703002] PM: Adding info for usb:1-0:1.0
> [   46.703430] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
> [   46.703460] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
> [   46.703460] hub 1-0:1.0: usb_probe_interface
> [   46.703491] hub 1-0:1.0: usb_probe_interface - got id
> [   46.703491] usb usb1: rpm_resume flags 0x4
> [   46.703491] usb usb1: rpm_resume returns 1
> [   46.703521] hub 1-0:1.0: USB hub found
> [   46.707427] hub 1-0:1.0: 3 ports detected
> [   46.715698] hub 1-0:1.0: standalone hub
> [   46.715698] hub 1-0:1.0: individual port power switching
> [   46.715728] hub 1-0:1.0: individual port over-current protection
> [   46.715728] hub 1-0:1.0: power on to power good time: 20ms
> [   46.715759] hub 1-0:1.0: local power source is good
> [   46.715759] hub 1-0:1.0: enabling power on all ports
> [   46.715820] driver: '1-0:1.0': driver_bound: bound to device 'hub'
> [   46.715820] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
> [   46.715850] device: 'ep_81': device_add
> [   46.717468] PM: Adding info for No Bus:ep_81
> [   46.717498] device: 'usbdev1.1': device_add
> [   46.717590] PM: Adding info for No Bus:usbdev1.1
> [   46.717773] drivers/usb/core/inode.c: creating file '001'
> [   46.717803] driver: 'usb1': driver_bound: bound to device 'usb'
> [   46.717803] bus: 'usb': really_probe: bound device usb1 to driver usb
> [   46.717834] device: 'ep_00': device_add
> [   46.717895] PM: Adding info for No Bus:ep_00
> [   46.717895] usb usb1: rpm_suspend flags 0xc
> [   46.717926] usb usb1: rpm_suspend returns -16
> [   46.717926] ehci-omap ehci-omap.0: ...powerup ports...
> [   46.747161] driver: 'ehci-omap.0': driver_bound: bound to device 'ehci-omap'
> [   46.747192] bus: 'platform': really_probe: bound device ehci-omap.0 to driver ehci-omap
> [   46.809661] ehci-omap ehci-omap.0: GetStatus port:1 status 001803 0 ACK POWER sig=j CSC CONNECT
> [   46.809692] hub 1-0:1.0: port 1: status 0501 change 0001
> [   46.911193] hub 1-0:1.0: state 7 ports 3 chg 0002 evt 0000
> [   46.911193] hub 1-0:1.0: rpm_resume flags 0x4
> [   46.911193] hub 1-0:1.0: rpm_resume returns 1
> [   46.911224] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
> [   46.973907] ehci-omap ehci-omap.0: port 1 high speed
> [   46.973907] ehci-omap ehci-omap.0: GetStatus port:1 status 001005 0 ACK POWER sig=se0 PE CONNECT
> [   47.036102] usb 1-1: new high speed USB device using ehci-omap and address 2
> [   47.044036] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 1
> [   47.044158] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 2
> [   47.044281] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 3
> [   47.044403] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 4
> [   47.044525] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 5
> [   47.044647] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 6
> [   47.044799] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 7
> [   47.044921] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 8
> ......
> 
> Anand, could you help to check it?
> 

Hi Ming Lei,

I'm able to reproduce this on my panda, and I have it working as of
linux-next-20101221 (the last version I tested last year) and failing
on linux-next-20101227 (which was the very next linux-next release).

Not sure why, but my Panda manages to get the VID:PID of the hub as
well, while yours does not even get there.

I may need a few more hours to debug this, unless someone beats me
to it. ;)

- Anand
