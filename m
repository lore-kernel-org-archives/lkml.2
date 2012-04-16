Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab2DPHXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:23:16 -0400
Received: from nm21.bullet.mail.bf1.yahoo.com ([98.139.212.180]:25358 "HELO
	nm21.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751527Ab2DPHXO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:23:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 57093.45909.bm@omp1008.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rwnbMN2k7/DGv1P8YFPgGoHsWd7UOffD1veQjBIDI8DN+GIdql+lQCee+1sIuKZ5dBIdYPBxeHuOUjdr+0oTPyVPLGHucHSI6rjWkbp4xYXHBQK553Uo8r8TgkdngVMzoOCBjQI2p6R4HB6dWY/qHtHfVXb05WHlFqr86pxHaj8=;
X-YMail-OSG: cEJb.QIVM1nQEWIYlvMKOgrpqCH.qeEg9L29Oj3GBkcy0bQ
 tpzdGmC20aFHD4LYpMy5iU7xTrVmsk0G2zrxg4NWdCqpe7x7zTlEo.Oh20ty
 65fTwtR_S8Q2frXDARZq_k147Ax5Cb1_0f886LoIFfGmxkPXIeP7Rf.cv68v
 _1qtZ.qjGaUGW_xozuW39drJb9HxQtQWVnh6GWcaN1znTFhCN7wsKF8JmMdQ
 Nd9UfSkllOcKtTcpB884sbfp.IhmjYgiFp2XUIXQ1rjXQ_orfL7SYRF8N2sF
 3TVucMztqRS_VKgo8oeiahssUROkU3bfC57IxeKJ0qk5ei5Ix6wQn94ClQVw
 UmGvjLLoMy.4U5TKMRXqEuBYKy0dvxZKrkCZ6iL0JdNpWGQO9rw5sFP2ziEb
 slvqjCNdX1lirk6vMq61MSB.aWbq_l_nGrFieSyCQfCEF6HmHOqZaeVjI9dl
 Yx3AWEEROx76NCPHwDiz5PWJgIigosM8SxVLhcGrTlekdno5.
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204152030.23148.rjw@sisk.pl> <201204152152.56048.rjw@sisk.pl> <201204152256.03198.rjw@sisk.pl>
Message-ID: <1334560992.32851.YahooMailNeo@web161806.mail.bf1.yahoo.com>
Date: Mon, 16 Apr 2012 00:23:12 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <201204152256.03198.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki

>>  OK, I know.  There simply are fewer BARs for bridges (and PCIe ports)
>>  and here we're attempting to overwrite the secondary status register.  
> Sigh.
>> 
>>  Well, I guess we should only retry the writes to BARs for Type 0 headers.
> 
> Which is done by the appended updated patch.  Can you please give it a try?


Ok, I tested v4 and also v3, which is in 3.4-rc3. On this laptop both versions
work equally: touchpad works after resume (no help for the card reader
problem, though).

Here is part of the resume log with version 4:

      1 ACPI: Waking up from system sleep state S3
      1 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 0x20005151, writing 0x5151)
      1 pcieport 0000:00:02.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:04.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:05.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:06.0: restoring config space at offset 0x1c (was 0x20002121, writing 0x2121)
      1 pcieport 0000:00:06.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:0a.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
      1 ahci 0000:00:11.0: restoring config space at offset 0x4 (was 0x2300003, writing 0x2300007)
      1 ohci_hcd 0000:00:12.0: restoring config space at offset 0x4 (was 0x2a00002, writing 0x2a00013)
      1 ehci_hcd 0000:00:12.2: BAR 0: set to [mem 0xd2408500-0xd24085ff] (PCI address [0xd2408500-0xd24085ff])
      1 ehci_hcd 0000:00:12.2: restoring config space at offset 0x4 (was 0x2b00000, writing 0x2b00013)
      1 ehci_hcd 0000:00:12.2: PME# disabled
      1 ohci_hcd 0000:00:13.0: restoring config space at offset 0x4 (was 0x2a00002, writing 0x2a00013)
      1 ehci_hcd 0000:00:13.2: BAR 0: set to [mem 0xd2408400-0xd24084ff] (PCI address [0xd2408400-0xd24084ff])
      1 ehci_hcd 0000:00:13.2: restoring config space at offset 0x4 (was 0x2b00000, writing 0x2b00013)
      1 ehci_hcd 0000:00:13.2: PME# disabled
      1 pata_atiixp 0000:00:14.1: restoring config space at offset 0x4 (was 0x2300011, writing 0x2300015)
      1 radeon 0000:01:00.0: restoring config space at offset 0x4 (was 0x100003, writing 0x100407)
      1 pci 0000:09:00.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100003)
      1 firewire_ohci 0000:0a:00.0: Refused to change power state, currently in D3
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x34 (was 0xffffffff, writing 0x44)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x24 (was 0xffffffff, writing 0xd1100c00)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x20 (was 0xffffffff, writing 0xd1100c80)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x14 (was 0xffffffff, writing 0xd1100d00)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100000)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x8 (was 0xffffffff, writing 0xc001000)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100007)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2380197b)
      1 sdhci-pci 0000:0a:00.1: Refused to change power state, currently in D3
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x34 (was 0xffffffff, writing 0xa4)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x24 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x20 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x14 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100b00)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x8 (was 0xffffffff, writing 0x8800000)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100007)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2382197b)
      1 pci 0000:0a:00.2: Refused to change power state, currently in D3
      1 pci 0000:0a:00.2: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 pci 0000:0a:00.2: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 pci 0000:0a:00.2: restoring config space at offset 0x34 (was 0xffffffff, writing 0xa4)
      1 pci 0000:0a:00.2: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 pci 0000:0a:00.2: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 pci 0000:0a:00.2: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x24 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x20 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x14 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100a00)
      1 pci 0000:0a:00.2: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 pci 0000:0a:00.2: restoring config space at offset 0x8 (was 0xffffffff, writing 0x8050100)
      1 pci 0000:0a:00.2: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100003)
      1 pci 0000:0a:00.2: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2381197b)
      1 jmb38x_ms 0000:0a:00.3: Refused to change power state, currently in D3
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x34 (was 0xffffffff, writing 0xa4)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x24 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x20 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x14 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100900)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x8 (was 0xffffffff, writing 0x8800000)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100007)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2383197b)
      1 pci 0000:0a:00.4: Refused to change power state, currently in D3
      1 pci 0000:0a:00.4: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 pci 0000:0a:00.4: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 pci 0000:0a:00.4: restoring config space at offset 0x34 (was 0xffffffff, writing 0xa4)
      1 pci 0000:0a:00.4: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 pci 0000:0a:00.4: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 pci 0000:0a:00.4: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x24 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x20 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x14 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100800)
      1 pci 0000:0a:00.4: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 pci 0000:0a:00.4: restoring config space at offset 0x8 (was 0xffffffff, writing 0x8800000)
      1 pci 0000:0a:00.4: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100007)
      1 pci 0000:0a:00.4: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2384197b)
      1 PM: noirq resume of devices complete after 440.260 msecs
      1 PM: early resume of devices complete after 0.152 msecs
      1 ohci_hcd 0000:00:12.0: enabling bus mastering
      1 ohci_hcd 0000:00:12.1: enabling bus mastering


Difference from v3:
--- /tmp/v3-uniq        2012-04-16 09:57:42.880521878 +0300
+++ /tmp/v4-uniq        2012-04-16 09:58:03.880545386 +0300
@@ -1019,11 +1018,11 @@
       1 Booting Node 0 Processor 1 APIC 0x1
       1 CPU1 is up
       1 ACPI: Waking up from system sleep state S3
-     11 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 0x20005151, writing 0x5151)
+      1 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 0x20005151, writing 0x5151)
       1 pcieport 0000:00:02.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
       1 pcieport 0000:00:04.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
       1 pcieport 0000:00:05.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
-     11 pcieport 0000:00:06.0: restoring config space at offset 0x1c (was 0x20002121, writing 0x2121)
+      1 pcieport 0000:00:06.0: restoring config space at offset 0x1c (was 0x20002121, writing 0x2121)
       1 pcieport 0000:00:06.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
       1 pcieport 0000:00:0a.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
       1 ahci 0000:00:11.0: restoring config space at offset 0x4 (was 0x2300003, writing 0x2300007)
@@ -1123,8 +1122,8 @@
       1 pci 0000:0a:00.4: restoring config space at offset 0x8 (was 0xffffffff, writing 0x8800000)
       1 pci 0000:0a:00.4: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100007)
       1 pci 0000:0a:00.4: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2384197b)
-      1 PM: noirq resume of devices complete after 460.315 msecs
-      1 PM: early resume of devices complete after 0.168 msecs
+      1 PM: noirq resume of devices complete after 440.260 msecs
+      1 PM: early resume of devices complete after 0.152 msecs
       1 ohci_hcd 0000:00:12.0: enabling bus mastering
       1 ohci_hcd 0000:00:12.1: enabling bus mastering
       1 ehci_hcd 0000:00:12.2: enabling bus mastering


(...if only radeon didn't add 10 seconds to resume time, that improvement of 20 msecs
would be very nice; that is another issue, of course, and not a new problem for this
kernel version:

[drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs aborting
[drm:atom_execute_table_locked] *ERROR* atombios stuck executing F8B6 (len 485, WS 0, PS 4) @ 0xF8F7
[drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs aborting
[drm:atom_execute_table_locked] *ERROR* atombios stuck executing F8B6 (len 485, WS 0, PS 4) @ 0xF8F7
PM: resume of devices complete after 12741.575 msecs
)


Thanks,

Mikko


> 
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PCI: Fix regression in pci_restore_state(), v4
> 
> Commit 26f41062f28de65e11d3cf353e52d0be73442be1
> 
>     PCI: check for pci bar restore completion and retry
> 
> attempted to address problems with PCI BAR restoration on systems
> where FLR had not been completed before pci_restore_state() was
> called, but it did that in an utterly wrong way.
> 
> First off, instead of retrying the writes for the BAR registers
> only, it did that for all of the PCI config space of the device,
> including the status registers (whose values after the write quite
> obviously need not be the same as the written ones).  Second, it
> added arbitrary delay to pci_restore_state() even for systems
> where the PCI config space restoration was successful at first
> attempt.  Finally, the mdelay(10) it added to every iteration of the
> writing loop was way too much of a delay for any reasonable device.
> 
> All of this actually caused resume failures for some devices on
> the Mikko's system.
> 
> To fix the regression, make pci_restore_state() only retry the
> writes to BAR registers and only for devices with Type 0 headers.
> Moreover, make it wait only if the next first read from the given
> register doesn't return the value written to it.  Finally, make it
> wait for 1 ms, instead of 10 ms, after every failing attempt to write
> into the device's config space.
> 
> Reported-by: Mikko Vinni <mmvinni@yahoo.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> drivers/pci/pci.c |   67 +++++++++++++++++++++++++++++++++++++-----------------
> 1 file changed, 46 insertions(+), 21 deletions(-)
> 
> Index: linux/drivers/pci/pci.c
> ===================================================================
> --- linux.orig/drivers/pci/pci.c
> +++ linux/drivers/pci/pci.c
> @@ -967,16 +967,47 @@ pci_save_state(struct pci_dev *dev)
>     return 0;
> }
> 
> +static void pci_restore_config_dword(struct pci_dev *pdev, int offset,
> +                     u32 saved_val, int retry)
> +{
> +    u32 val;
> +
> +    pci_read_config_dword(pdev, offset, &val);
> +    if (val == saved_val)
> +        return;
> +
> +    for (;;) {
> +        dev_dbg(&pdev->dev, "restoring config space at offset 
> "
> +            "%#x (was %#x, writing %#x)\n", offset, val, 
> saved_val);
> +        pci_write_config_dword(pdev, offset, saved_val);
> +        if (retry-- <= 0)
> +            return;
> +
> +        pci_read_config_dword(pdev, offset, &val);
> +        if (val == saved_val)
> +            return;
> +
> +        mdelay(1);
> +    }
> +}
> +
> +static void pci_restore_config_space(struct pci_dev *pdev, int start, int end,
> +                     int retry)
> +{
> +    int index;
> +
> +    for (index = end; index >= start; index--)
> +        pci_restore_config_dword(pdev, 4 * index,
> +                     pdev->saved_config_space[index],
> +                     retry);
> +}
> +
> /** 
>   * pci_restore_state - Restore the saved state of a PCI device
>   * @dev: - PCI device that we're dealing with
>   */
> void pci_restore_state(struct pci_dev *dev)
> {
> -    int i;
> -    u32 val;
> -    int tries;
> -
>     if (!dev->state_saved)
>         return;
> 
> @@ -984,24 +1015,18 @@ void pci_restore_state(struct pci_dev *d
>     pci_restore_pcie_state(dev);
>     pci_restore_ats_state(dev);
> 
> -    /*
> -     * The Base Address register should be programmed before the command
> -     * register(s)
> -     */
> -    for (i = 15; i >= 0; i--) {
> -        pci_read_config_dword(dev, i * 4, &val);
> -        tries = 10;        
> -        while (tries && val != dev->saved_config_space[i]) {
> -            dev_dbg(&dev->dev, "restoring config "
> -                "space at offset %#x (was %#x, writing %#x)\n",
> -                i, val, (int)dev->saved_config_space[i]);
> -            pci_write_config_dword(dev,i * 4,
> -                dev->saved_config_space[i]);
> -            pci_read_config_dword(dev, i * 4, &val);
> -            mdelay(10);
> -            tries--;
> -        }
> +    if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL) {
> +        pci_restore_config_space(dev, 10, 15, 0);
> +        /*
> +         * The Base Address register should be programmed before the
> +         * command register(s)
> +         */
> +        pci_restore_config_space(dev, 4, 9, 10);
> +        pci_restore_config_space(dev, 0, 3, 0);
> +    } else {
> +        pci_restore_config_space(dev, 0, 15, 0);
>     }
> +
>     pci_restore_pcix_state(dev);
>     pci_restore_msi_state(dev);
>     pci_restore_iov_state(dev);
> 
