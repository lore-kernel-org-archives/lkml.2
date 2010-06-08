Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab0FHFJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 01:09:14 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:48111 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959Ab0FHFJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 01:09:12 -0400
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>
CC: Chris McDermott <lcm@us.ibm.com>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Date: Tue, 8 Jun 2010 10:38:39 +0530
Subject: RE: [Regression] mptsas won't boot with 2.6.35-rc2
Thread-Topic: [Regression] mptsas won't boot with 2.6.35-rc2
Thread-Index: AcsGvAXckdUHSMG/Q4OBPIkCxqZ6gAADCraQ
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249029006CCE0@inbmail02.lsi.com>
References: <1275968204.3114.30.camel@localhost.localdomain>
In-Reply-To: <1275968204.3114.30.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5859Sim000513



> -----Original Message-----
> From: john stultz [mailto:johnstul@us.ibm.com]
> Sent: Tuesday, June 08, 2010 9:07 AM
> To: lkml
> Cc: Chris McDermott; James.Bottomley@suse.de; Desai, Kashyap
> Subject: [Regression] mptsas won't boot with 2.6.35-rc2
> 
> With 2.6.35-rc2 one of my LS21 boxes stopped booting. I'm seeing:
> 
> Fusion MPT SAS Host driver 3.04.15
> mptsas 0000:03:04.0: can't find IRQ for PCI INT A; probably buggy MP
> table
John,

I have seen similar issue in past and It was solve at pci  subsystem level.
I am not sure what was a change but yes it was IRQ mapping issue at pci subsystem of OS.

So my suggestion to you is use 2.6.34 where things are working fine and see what a behavior is with 
3.04.14 driver and 3.04.15 driver.


~Kashyap


> mptbase: ioc0: Initiating bringup
> ioc0: LSISAS1064 A3: Capabilities={Initiator}
> mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
> mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2,
> action 0
> mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
> mptbase: ioc0: Initiating recovery
> mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2,
> action 0
> 
> 
> 
> Where as 2.6.34 with the same .config boots fine:
> 
> Fusion MPT SAS Host driver 3.04.14
> mptsas 0000:03:04.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> mptbase: ioc0: Initiating bringup
> ioc0: LSISAS1064 A3: Capabilities={Initiator}
> scsi0 : ioc0: LSISAS1064 A3, FwRev=01125400h, Ports=1, MaxQ=511, IRQ=19
> mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0,
> sas_addr 0x5000c500021cbc49
> scsi 0:0:0:0: Direct-Access     IBM-ESXS ST973401SS       B51D PQ: 0
> ANSI: 5
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> Fusion MPT misc device (ioctl) driver 3.04.14
> sd 0:0:0:0: [sda] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports
> DPO and FUA
> mptctl: Registered with Fusion MPT base driver
> mptctl: /dev/mptctl @ (major,minor=10,220)
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ACPI: PCI Interrupt Link [LPUS] enabled at IRQ 5
> ehci_hcd 0000:00:03.2: PCI INT A -> Link[LPUS] -> GSI 5 (level, low) ->
> IRQ 5
> ehci_hcd 0000:00:03.2: EHCI Host Controller
> ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
> sda: sda1 sda2 sda3 sda4
> ...
> 
> 
> Although from the warning, this may be irq routing related, not driver
> related. Any suggestions?
> 
> thanks
> -john
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
