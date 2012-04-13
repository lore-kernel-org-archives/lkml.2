Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2DMUxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:53:20 -0400
Received: from nm6-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.146]:24100 "HELO
	nm6-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755981Ab2DMUxT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:53:19 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2012 16:53:18 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 931785.79643.bm@omp1024.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=fhFRsnjGqoIZ36EMMBVh5F+ZhnZj7utQu9rxfutPezqNLiIiSg8nylwfrADL7b9swoqgAVOFjqF59/P7yNT3B9piRkHlHcX4I8A3T3fnv6o7Bfj9FMebIbcG6MIwiG9npk+sEwy+iIDg386CaHDmIByFWvtTFowQrFLQKFJ8J1g=;
X-YMail-OSG: uDZz6OcVM1lUryhVcMMGQXuzUQzEABgyDg8um2iLXO9gB5v
 TqIxBYvqvCrPInqjdGlvgahxIZCTx940F52JCY2xEbPVcqMKVj_pBGhkZ54P
 gDsKbwO2l9HEECESbN53R3a10rEXFHdaDeKgPPZjpPe2Psv48_YxBkCs1rK8
 19AA9v.G2axdpFjE2IahxQzkG93NS_QrXiFjkbRxCzTR4.Z8S5XhO1B.l1AU
 68UnhECPzcrz9h6efLf4pC8K.tCU4kokhgzY_HfdUKnY4G203u2Cs6grPNzh
 2HbyFOYYijTEcD2ToLlv3L7H21V7lmy_7X96uQeauTHRZ4nTNhcjp8Llv6qU
 idCKIy2d0ei0xB4K9vt3bAW4TE5Mnnjacf.lQaXGLsY2liw7_KnF_zwzdVvY
 VTWD.VJn1tzt4Bnn0H0OxkcOsPPrsyvTfZVCvVfyjIsJ.tEtXPNUAPM78y.h
 4NL_EoQK4NjTUyW9T757gSP51nxNnE10RrFwtiMvy7WVncBDkYIs5SZl3dax
 _tJNO46ipIOvguFUv749UW.37lMxAH6LDYwGsvmOi2amCfqJh8GsYceTLBrH
 JqYQNQXNFZWwU0WOctA4z.mMv0p7gN6PqyiUUNXDzIx7Y
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204132118.22074.rjw@sisk.pl> <1334346546.93033.YahooMailNeo@web161806.mail.bf1.yahoo.com> <201204132219.23106.rjw@sisk.pl>
Message-ID: <1334350068.79333.YahooMailNeo@web161804.mail.bf1.yahoo.com>
Date: Fri, 13 Apr 2012 13:47:48 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <201204132219.23106.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki:

> On Friday, April 13, 2012, Mikko Vinni wrote:
>>  From: Rafael J. Wysocki:
>> 
>>  > On Friday, April 13, 2012, Mikko Vinni wrote:
>>  >>  Bug report:
>>  >>    https://bugzilla.kernel.org/show_bug.cgi?id=43099
>>  >> 

^^^ some of the home-work is already there, including dmesg with and without the patch
with PCI debug on, which hopefully does the same as dev_info

> 
> Please change that dev_dbg() in pci_restore_state() into dev_info()
> and see how many times it gets printed with the commit applied (not reverted).


I ran the dmesg through "uniq -c" and it looks like this:

      1 ACPI: Low-level resume complete
      1 PM: Restoring platform NVS memory
      1 Enabling non-boot CPUs ...
      1 Booting Node 0 Processor 1 APIC 0x1
      1 CPU1 is up
      1 ACPI: Waking up from system sleep state S3
     10 pcieport 0000:00:02.0: restoring config space at offset 0x7 (was 0x20005151, writing 0x5151)
      1 pcieport 0000:00:02.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:04.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:05.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
     10 pcieport 0000:00:06.0: restoring config space at offset 0x7 (was 0x20002121, writing 0x2121)
      1 pcieport 0000:00:06.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:0a.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 ahci 0000:00:11.0: restoring config space at offset 0x1 (was 0x2300003, writing 0x2300007)
      1 ohci_hcd 0000:00:12.0: restoring config space at offset 0x1 (was 0x2a00002, writing 0x2a00013)
      1 ehci_hcd 0000:00:12.2: BAR 0: set to [mem 0xd2408500-0xd24085ff] (PCI address [0xd2408500-0xd24085ff])
      1 ehci_hcd 0000:00:12.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00013)
      1 ehci_hcd 0000:00:12.2: PME# disabled
      1 ohci_hcd 0000:00:13.0: restoring config space at offset 0x1 (was 0x2a00002, writing 0x2a00013)
      1 ehci_hcd 0000:00:13.2: BAR 0: set to [mem 0xd2408400-0xd24084ff] (PCI address [0xd2408400-0xd24084ff])
      1 ehci_hcd 0000:00:13.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00013)
      1 ehci_hcd 0000:00:13.2: PME# disabled
      1 pata_atiixp 0000:00:14.1: restoring config space at offset 0x1 (was 0x2300011, writing 0x2300015)
      1 radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x100003, writing 0x100407)
      1 r8169 0000:09:00.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 firewire_ohci 0000:0a:00.0: Refused to change power state, currently in D3
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xd (was 0xffffffff, writing 0x44)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x9 (was 0xffffffff, writing 0xd1100c00)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x8 (was 0xffffffff, writing 0xd1100c80)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x5 (was 0xffffffff, writing 0xd1100d00)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100000)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x2 (was 0xffffffff, writing 0xc001000)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100007)
     10 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2380197b)
      1 sdhci-pci 0000:0a:00.1: Refused to change power state, currently in D3
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xd (was 0xffffffff, writing 0xa4)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x5 (was 0xffffffff, writing 0x0)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100b00)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x2 (was 0xffffffff, writing 0x8800000)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100007)
     10 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2382197b)
      1 pci 0000:0a:00.2: Refused to change power state, currently in D3
     10 pci 0000:0a:00.2: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
     10 pci 0000:0a:00.2: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.2: restoring config space at offset 0xd (was 0xffffffff, writing 0xa4)
     10 pci 0000:0a:00.2: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.2: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
     10 pci 0000:0a:00.2: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.2: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.2: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.2: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.2: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.2: restoring config space at offset 0x5 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.2: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100a00)
     10 pci 0000:0a:00.2: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
     10 pci 0000:0a:00.2: restoring config space at offset 0x2 (was 0xffffffff, writing 0x8050100)
     10 pci 0000:0a:00.2: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100003)
     10 pci 0000:0a:00.2: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2381197b)
      1 jmb38x_ms 0000:0a:00.3: Refused to change power state, currently in D3
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0xd (was 0xffffffff, writing 0xa4)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x5 (was 0xffffffff, writing 0x0)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100900)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x2 (was 0xffffffff, writing 0x8800000)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100007)
     10 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2383197b)
      1 pci 0000:0a:00.4: Refused to change power state, currently in D3
     10 pci 0000:0a:00.4: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
     10 pci 0000:0a:00.4: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.4: restoring config space at offset 0xd (was 0xffffffff, writing 0xa4)
     10 pci 0000:0a:00.4: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.4: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
     10 pci 0000:0a:00.4: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.4: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.4: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.4: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.4: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.4: restoring config space at offset 0x5 (was 0xffffffff, writing 0x0)
     10 pci 0000:0a:00.4: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100800)
     10 pci 0000:0a:00.4: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
     10 pci 0000:0a:00.4: restoring config space at offset 0x2 (was 0xffffffff, writing 0x8800000)
     10 pci 0000:0a:00.4: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100007)
     10 pci 0000:0a:00.4: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2384197b)
      1 PM: noirq resume of devices complete after 8474.806 msecs
      1 PM: early resume of devices complete after 0.194 msecs
      1 ohci_hcd 0000:00:12.0: enabling bus mastering


Interestingly, this only seems to happen after the first s2ram.
https://bugzilla.kernel.org/attachment.cgi?id=72904 contains the dmesg from
three s2ram's, and after the second and third one write seems to be enough.
Even the failing firewire/card reader (another bug) is more quiet.

... (after the second s2ram, touchpad works after this)
      1 CPU1 is up
      1 ACPI: Waking up from system sleep state S3
      1 pcieport 0000:00:02.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:04.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:05.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:06.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:0a.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
      1 ahci 0000:00:11.0: restoring config space at offset 0x1 (was 0x2300003, writing 0x2300007)
      1 ohci_hcd 0000:00:12.0: restoring config space at offset 0x1 (was 0x2a00002, writing 0x2a00013)
      1 ehci_hcd 0000:00:12.2: BAR 0: set to [mem 0xd2408500-0xd24085ff] (PCI address [0xd2408500-0xd24085ff])
      1 ehci_hcd 0000:00:12.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00013)
      1 ehci_hcd 0000:00:12.2: PME# disabled
... 


Mikko


> 
> [Margin note: I think it would make more sense to read the value from
> the register _after_ and not before the waiting and I'm not exactly sure why
> msleep() is not used.]
> 
> Thanks,
> Rafael
> 
