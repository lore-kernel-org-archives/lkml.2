Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab0FHDgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:36:53 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54180 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab0FHDgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:36:51 -0400
Subject: [Regression] mptsas won't boot with 2.6.35-rc2
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Chris McDermott <lcm@us.ibm.com>, James.Bottomley@suse.de,
       Kashyap.Desai@lsi.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 20:36:44 -0700
Message-ID: <1275968204.3114.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.35-rc2 one of my LS21 boxes stopped booting. I'm seeing:

Fusion MPT SAS Host driver 3.04.15
mptsas 0000:03:04.0: can't find IRQ for PCI INT A; probably buggy MP table
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1064 A3: Capabilities={Initiator}
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2, action 0



Where as 2.6.34 with the same .config boots fine:

Fusion MPT SAS Host driver 3.04.14
mptsas 0000:03:04.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1064 A3: Capabilities={Initiator}
scsi0 : ioc0: LSISAS1064 A3, FwRev=01125400h, Ports=1, MaxQ=511, IRQ=19
mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x5000c500021cbc49
scsi 0:0:0:0: Direct-Access     IBM-ESXS ST973401SS       B51D PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
Fusion MPT misc device (ioctl) driver 3.04.14
sd 0:0:0:0: [sda] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [LPUS] enabled at IRQ 5
ehci_hcd 0000:00:03.2: PCI INT A -> Link[LPUS] -> GSI 5 (level, low) -> IRQ 5
ehci_hcd 0000:00:03.2: EHCI Host Controller
ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
sda: sda1 sda2 sda3 sda4
...


Although from the warning, this may be irq routing related, not driver
related. Any suggestions?

thanks
-john



