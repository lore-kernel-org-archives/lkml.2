Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2LMLpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:45:53 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:54198 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2LMLpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:45:50 -0500
Message-ID: <50C9BFD8.3070802@huawei.com>
Date: Thu, 13 Dec 2012 19:45:28 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 0/6] ACPI: Change the ACPI namespace scanning code ordering
References: <8498184.VilrUmatxI@vostro.rjw.lan>
In-Reply-To: <8498184.VilrUmatxI@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi rafael,
   I tested the pachset in our IA64 machine, system boot up log seems ok, but when do IOH hot plug, there are two small
problems that missing match and start acpi devices for the top acpi device(eg. pci host bridge), refer https://lkml.org/lkml/2012/12/12/268.

Test Machine: IA64,2 physical nodes;
PCI topology:
-+-[0000:40]-+-00.0-[0000:41]--
 |           +-01.0-[0000:42]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
 |           |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
 |           +-03.0-[0000:43]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
 |           +-04.0-[0000:44]--
 |           +-05.0-[0000:45]--
 |           +-07.0-[0000:46]--
 |           +-0d.0  Intel Corporation Device 343a
 |           +-0d.1  Intel Corporation Device 343b
 |           +-0d.2  Intel Corporation Device 343c
 |           +-0d.3  Intel Corporation Device 343d
 |           +-0d.4  Intel Corporation 5520/5500/X58 Physical Layer Port 0
 |           +-0d.5  Intel Corporation 5520/5500 Physical Layer Port 1
 |           +-0d.6  Intel Corporation Device 341a
 |           +-0d.7  Intel Corporation Device 341b
 |           +-0e.0  Intel Corporation Device 341c
 |           +-0e.1  Intel Corporation Device 341d
 |           +-0e.2  Intel Corporation Device 341e
 |           +-0e.3  Intel Corporation Device 341f
 |           +-0e.4  Intel Corporation Device 3439
 |           +-0f.0  Intel Corporation Device 3424
 |           +-10.0  Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0
 |           +-10.1  Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0
 |           +-11.0  Intel Corporation 5520/5500 Physical and Link Layer Registers Port 1
 |           +-11.1  Intel Corporation 5520/5500 Routing & Protocol Layer Register Port 1
 |           +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
 |           +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
 |           +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
 |           +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
 |           +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
 |           +-15.0  Intel Corporation 5520/5500/X58 Trusted Execution Technology Registers
 |           +-16.0  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.1  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.2  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.3  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.4  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.5  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.6  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           \-16.7  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 \-[0000:00]-+-00.0  Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
             +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
             +-04.0-[0000:03]--
             +-05.0-[0000:04]--
             +-07.0-[0000:05]--+-00.0  nVidia Corporation GT218 [GeForce G210]
             |                 \-00.1  nVidia Corporation High Definition Audio Controller
             +-0d.0  Intel Corporation Device 343a
             +-0d.1  Intel Corporation Device 343b
             +-0d.2  Intel Corporation Device 343c
             +-0d.3  Intel Corporation Device 343d
             +-0d.4  Intel Corporation 5520/5500/X58 Physical Layer Port 0
             +-0d.5  Intel Corporation 5520/5500 Physical Layer Port 1
             +-0d.6  Intel Corporation Device 341a
             +-0d.7  Intel Corporation Device 341b
             +-0e.0  Intel Corporation Device 341c
             +-0e.1  Intel Corporation Device 341d
             +-0e.2  Intel Corporation Device 341e
             +-0e.3  Intel Corporation Device 341f
             +-0e.4  Intel Corporation Device 3439
             +-0f.0  Intel Corporation Device 3424
             +-10.0  Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0
             +-10.1  Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0
             +-11.0  Intel Corporation 5520/5500 Physical and Link Layer Registers Port 1
             +-11.1  Intel Corporation 5520/5500 Routing & Protocol Layer Register Port 1
             +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
             +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
             +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
             +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
             +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
             +-15.0  Intel Corporation 5520/5500/X58 Trusted Execution Technology Registers
             +-16.0  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.1  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.2  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.3  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.4  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.5  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.6  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.7  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-1a.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
             +-1a.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
             +-1a.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
             +-1a.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
             +-1c.0-[0000:06]--
             +-1c.1-[0000:07]--
             +-1c.2-[0000:08]--
             +-1c.3-[0000:09]--
             +-1c.4-[0000:0a]----00.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z11/Z11M
             +-1c.5-[0000:0b]--
             +-1d.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
             +-1d.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
             +-1d.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
             +-1d.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
             +-1e.0-[0000:0c]--
             +-1f.0  Intel Corporation 82801JIB (ICH10) LPC Interface Controller
             +-1f.2  Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1
             +-1f.3  Intel Corporation 82801JI (ICH10 Family) SMBus Controller
             \-1f.5  Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2

linux kernel version:
https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git + ACPI: Change the ACPI namespace scanning code ordering six patches +
IOH hotplug partial patches from https://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git/for-pci-next-2


IOH hotplug dmesg log at the end.

========================================================================system boot up dmesg log================================================
ACPI: bus type pci registered
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOSAPIC for interrupt routing
acpi_bus_scan: start 1
acpi_bus_check_add: acpi_device LNXSYSTM:00 added, add_type 2
acpi_bus_check_add: acpi_device device:00 added, add_type 2
acpi_bus_check_add: acpi_device ACPI0004:00 added, add_type 2
acpi_bus_check_add: acpi_device ACPI0004:01 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:00 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:01 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:02 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:03 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:04 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:05 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:06 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:07 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C80:00 added, add_type 2
acpi_bus_check_add: acpi_device ACPI0004:02 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:08 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:09 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:0a added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:0b added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:0c added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:0d added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:0e added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:0f added, add_type 2
acpi_bus_check_add: acpi_device PNP0C80:01 added, add_type 2
acpi_bus_check_add: acpi_device PNP0A08:00 added, add_type 2
acpi_bus_check_add: acpi_device ACPI0009:00 added, add_type 2
acpi_bus_check_add: acpi_device device:01 added, add_type 2
acpi_bus_check_add: acpi_device device:02 added, add_type 2
acpi_bus_check_add: acpi_device device:03 added, add_type 2
acpi_bus_check_add: acpi_device device:04 added, add_type 2
acpi_bus_check_add: acpi_device device:05 added, add_type 2
acpi_bus_check_add: acpi_device device:06 added, add_type 2
acpi_bus_check_add: acpi_device device:07 added, add_type 2
acpi_bus_check_add: acpi_device device:08 added, add_type 2
acpi_bus_check_add: acpi_device device:09 added, add_type 2
acpi_bus_check_add: acpi_device device:0a added, add_type 2
acpi_bus_check_add: acpi_device device:0b added, add_type 2
acpi_bus_check_add: acpi_device device:0c added, add_type 2
acpi_bus_check_add: acpi_device device:0d added, add_type 2
acpi_bus_check_add: acpi_device device:0e added, add_type 2
acpi_bus_check_add: acpi_device device:0f added, add_type 2
acpi_bus_check_add: acpi_device device:10 added, add_type 2
acpi_bus_check_add: acpi_device device:11 added, add_type 2
acpi_bus_check_add: acpi_device device:12 added, add_type 2
acpi_bus_check_add: acpi_device device:13 added, add_type 2
acpi_bus_check_add: acpi_device device:14 added, add_type 2
acpi_bus_check_add: acpi_device device:15 added, add_type 2
acpi_bus_check_add: acpi_device device:16 added, add_type 2
acpi_bus_check_add: acpi_device device:17 added, add_type 2
acpi_bus_check_add: acpi_device device:18 added, add_type 2
acpi_bus_check_add: acpi_device device:19 added, add_type 2
acpi_bus_check_add: acpi_device device:1a added, add_type 2
acpi_bus_check_add: acpi_device device:1b added, add_type 2
acpi_bus_check_add: acpi_device device:1c added, add_type 2
acpi_bus_check_add: acpi_device device:1d added, add_type 2
acpi_bus_check_add: acpi_device device:1e added, add_type 2
acpi_bus_check_add: acpi_device device:1f added, add_type 2
acpi_bus_check_add: acpi_device device:20 added, add_type 2
acpi_bus_check_add: acpi_device device:21 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C0F:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C0F:01 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C0F:02 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C0F:03 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C0F:04 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C0F:05 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C0F:06 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C0F:07 added, add_type 2
acpi_bus_check_add: acpi_device PNP0200:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0B00:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0000:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C04:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0100:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0800:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C02:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0700:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0400:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0F03:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0303:00 added, add_type 2
acpi_bus_check_add: acpi_device PNP0501:00 added, add_type 2
acpi_bus_check_add: acpi_device device:22 added, add_type 2
acpi_bus_check_add: acpi_device device:23 added, add_type 2
acpi_bus_check_add: acpi_device device:24 added, add_type 2
acpi_bus_check_add: acpi_device device:25 added, add_type 2
acpi_bus_check_add: acpi_device device:26 added, add_type 2
acpi_bus_check_add: acpi_device device:27 added, add_type 2
acpi_bus_check_add: acpi_device device:28 added, add_type 2
acpi_bus_check_add: acpi_device device:29 added, add_type 2
acpi_bus_check_add: acpi_device device:2a added, add_type 2
acpi_bus_check_add: acpi_device device:2b added, add_type 2
acpi_bus_check_add: acpi_device device:2c added, add_type 2
acpi_bus_check_add: acpi_device device:2d added, add_type 2
acpi_bus_check_add: acpi_device device:2e added, add_type 2
acpi_bus_check_add: acpi_device device:2f added, add_type 2
acpi_bus_check_add: acpi_device device:30 added, add_type 2
acpi_bus_check_add: acpi_device device:31 added, add_type 2
acpi_bus_check_add: acpi_device device:32 added, add_type 2
acpi_bus_check_add: acpi_device device:33 added, add_type 2
acpi_bus_check_add: acpi_device device:34 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C0E:00 added, add_type 2
acpi_bus_check_add: acpi_device ACPI0004:03 added, add_type 2
acpi_bus_check_add: acpi_device ACPI0004:04 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:10 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:11 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:12 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:13 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:14 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:15 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:16 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:17 added, add_type 2
acpi_bus_check_add: acpi_device PNP0C80:02 added, add_type 2
acpi_bus_check_add: acpi_device ACPI0004:05 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:18 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:19 added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:1a added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:1b added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:1c added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:1d added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:1e added, add_type 2
acpi_bus_check_add: acpi_device LNXCPU:1f added, add_type 2
acpi_bus_check_add: acpi_device PNP0C80:03 added, add_type 2
acpi_bus_check_add: acpi_device PNP0A08:01 added, add_type 2
acpi_bus_check_add: acpi_device ACPI0009:01 added, add_type 2
acpi_bus_check_add: acpi_device device:35 added, add_type 2
acpi_bus_check_add: acpi_device device:36 added, add_type 2
acpi_bus_check_add: acpi_device device:37 added, add_type 2
acpi_bus_check_add: acpi_device device:38 added, add_type 2
acpi_bus_check_add: acpi_device device:39 added, add_type 2
acpi_bus_check_add: acpi_device device:3a added, add_type 2
acpi_bus_check_add: acpi_device device:3b added, add_type 2
acpi_bus_check_add: acpi_device device:3c added, add_type 2
acpi_bus_check_add: acpi_device device:3d added, add_type 2
acpi_bus_check_add: acpi_device device:3e added, add_type 2
acpi_bus_check_add: acpi_device device:3f added, add_type 2
acpi_bus_check_add: acpi_device device:40 added, add_type 2
acpi_bus_check_add: acpi_device device:41 added, add_type 2
acpi_bus_check_add: acpi_device device:42 added, add_type 2
acpi_bus_check_add: acpi_device device:43 added, add_type 2
acpi_bus_check_add: acpi_device device:44 added, add_type 2
acpi_bus_check_add: acpi_device device:45 added, add_type 2
acpi_bus_check_add: acpi_device device:46 added, add_type 2
acpi_bus_check_add: acpi_device device:47 added, add_type 2
acpi_bus_check_add: acpi_device device:48 added, add_type 2
acpi_bus_check_add: acpi_device device:49 added, add_type 2
acpi_bus_check_add: acpi_device device:4a added, add_type 2
acpi_bus_check_add: acpi_device device:4b added, add_type 2
acpi_bus_check_add: acpi_device device:4c added, add_type 2
acpi_bus_check_add: acpi_device device:4d added, add_type 2
acpi_bus_check_add: acpi_device device:4e added, add_type 2
acpi_bus_check_add: acpi_device device:4f added, add_type 2
acpi_bus_check_add: acpi_device device:50 added, add_type 2
acpi_bus_match_device: attach driver for device device:00
acpi_bus_match_device: acpi_device device:00, attached driver is NULL
acpi_bus_match_device: attach driver for device ACPI0004:00
acpi_bus_match_device: acpi_device ACPI0004:00, attached driver is NULL
acpi_bus_match_device: attach driver for device ACPI0004:01
acpi_bus_match_device: acpi_device ACPI0004:01, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:00
acpi_bus_match_device: acpi_device LNXCPU:00, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:01
acpi_bus_match_device: acpi_device LNXCPU:01, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:02
acpi_bus_match_device: acpi_device LNXCPU:02, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:03
acpi_bus_match_device: acpi_device LNXCPU:03, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:04
acpi_bus_match_device: acpi_device LNXCPU:04, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:05
acpi_bus_match_device: acpi_device LNXCPU:05, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:06
acpi_bus_match_device: acpi_device LNXCPU:06, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:07
acpi_bus_match_device: acpi_device LNXCPU:07, attached driver is NULL
acpi_bus_match_device: attach driver for device PNP0C80:00
acpi_bus_match_device: acpi_device PNP0C80:00, attached driver is NULL
acpi_bus_match_device: attach driver for device ACPI0004:02
acpi_bus_match_device: acpi_device ACPI0004:02, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:08
acpi_bus_match_device: acpi_device LNXCPU:08, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:09
acpi_bus_match_device: acpi_device LNXCPU:09, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:0a
acpi_bus_match_device: acpi_device LNXCPU:0a, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:0b
acpi_bus_match_device: acpi_device LNXCPU:0b, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:0c
acpi_bus_match_device: acpi_device LNXCPU:0c, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:0d
acpi_bus_match_device: acpi_device LNXCPU:0d, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:0e
acpi_bus_match_device: acpi_device LNXCPU:0e, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:0f
acpi_bus_match_device: acpi_device LNXCPU:0f, attached driver is NULL
acpi_bus_match_device: attach driver for device PNP0C80:01
acpi_bus_match_device: acpi_device PNP0C80:01, attached driver is NULL
acpi_bus_match_device: attach driver for device PNP0A08:00
acpi_bus_match: device PNP0A08:00 find match driver pci_root
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x1000-0x8fff]
pci_root PNP0A08:00: host bridge window [mem 0x50000000-0x7fffffff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-3f]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x1000-0x8fff]
pci_bus 0000:00: root bus resource [mem 0x50000000-0x7fffffff]
pci 0000:00:00.0: [8086:3407] type 00 class 0x060000
pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: [8086:340b] type 01 class 0x060400
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0d.0: [8086:343a] type 00 class 0x060000
pci 0000:00:0d.1: [8086:343b] type 00 class 0x060000
pci 0000:00:0d.2: [8086:343c] type 00 class 0x060000
pci 0000:00:0d.3: [8086:343d] type 00 class 0x060000
pci 0000:00:0d.4: [8086:3418] type 00 class 0x060000
pci 0000:00:0d.5: [8086:3419] type 00 class 0x060000
pci 0000:00:0d.6: [8086:341a] type 00 class 0x060000
pci 0000:00:0d.7: [8086:341b] type 00 class 0x060000
pci 0000:00:0e.0: [8086:341c] type 00 class 0x060000
pci 0000:00:0e.1: [8086:341d] type 00 class 0x060000
pci 0000:00:0e.2: [8086:341e] type 00 class 0x060000
pci 0000:00:0e.3: [8086:341f] type 00 class 0x060000
pci 0000:00:0e.4: [8086:3439] type 00 class 0x060000
pci 0000:00:0f.0: [8086:3424] type 00 class 0x110100
pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
pci 0000:00:11.0: [8086:3427] type 00 class 0x080000
pci 0000:00:11.1: [8086:3428] type 00 class 0x080000
pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
pci 0000:00:13.0: reg 10: [mem 0x68320000-0x68320fff]
pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
pci 0000:00:15.0: [8086:342f] type 00 class 0x080020
pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
pci 0000:00:16.0: reg 10: [mem 0x68300000-0x68303fff 64bit]
pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
pci 0000:00:16.1: reg 10: [mem 0x68304000-0x68307fff 64bit]
pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
pci 0000:00:16.2: reg 10: [mem 0x68308000-0x6830bfff 64bit]
pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
pci 0000:00:16.3: reg 10: [mem 0x6830c000-0x6830ffff 64bit]
pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
pci 0000:00:16.4: reg 10: [mem 0x68310000-0x68313fff 64bit]
pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
pci 0000:00:16.5: reg 10: [mem 0x68314000-0x68317fff 64bit]
pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
pci 0000:00:16.6: reg 10: [mem 0x68318000-0x6831bfff 64bit]
pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
pci 0000:00:16.7: reg 10: [mem 0x6831c000-0x6831ffff 64bit]
pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
pci 0000:00:1a.0: reg 20: [io  0x50c0-0x50df]
pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
pci 0000:00:1a.1: reg 20: [io  0x50a0-0x50bf]
pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
pci 0000:00:1a.2: reg 20: [io  0x5080-0x509f]
pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
pci 0000:00:1a.7: reg 10: [mem 0x68321400-0x683217ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:3a42] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: [8086:3a44] type 01 class 0x060400
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: [8086:3a46] type 01 class 0x060400
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: [8086:3a4a] type 01 class 0x060400
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 20: [io  0x5060-0x507f]
pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 20: [io  0x5040-0x505f]
pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 20: [io  0x5020-0x503f]
pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 10: [mem 0x68321000-0x683213ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
pci 0000:00:1f.0: [8086:3a18] type 00 class 0x060100
pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
pci 0000:00:1f.2: reg 10: [io  0x5138-0x513f]
pci 0000:00:1f.2: reg 14: [io  0x514c-0x514f]
pci 0000:00:1f.2: reg 18: [io  0x5130-0x5137]
pci 0000:00:1f.2: reg 1c: [io  0x5148-0x514b]
pci 0000:00:1f.2: reg 20: [io  0x5110-0x511f]
pci 0000:00:1f.2: reg 24: [io  0x5100-0x510f]
pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 10: [mem 0x68321800-0x683218ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x5000-0x501f]
pci 0000:00:1f.5: [8086:3a26] type 00 class 0x010185
pci 0000:00:1f.5: reg 10: [io  0x5128-0x512f]
pci 0000:00:1f.5: reg 14: [io  0x5144-0x5147]
pci 0000:00:1f.5: reg 18: [io  0x5120-0x5127]
pci 0000:00:1f.5: reg 1c: [io  0x5140-0x5143]
pci 0000:00:1f.5: reg 20: [io  0x50f0-0x50ff]
pci 0000:00:1f.5: reg 24: [io  0x50e0-0x50ef]
pci 0000:01:00.0: [8086:10c9] type 00 class 0x020000
pci 0000:01:00.0: reg 10: [mem 0x68260000-0x6827ffff]
pci 0000:01:00.0: reg 14: [mem 0x68240000-0x6825ffff]
pci 0000:01:00.0: reg 18: [io  0x4020-0x403f]
pci 0000:01:00.0: reg 1c: [mem 0x68284000-0x68287fff]
pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
pci 0000:01:00.1: [8086:10c9] type 00 class 0x020000
pci 0000:01:00.1: reg 10: [mem 0x68220000-0x6823ffff]
pci 0000:01:00.1: reg 14: [mem 0x68200000-0x6821ffff]
pci 0000:01:00.1: reg 18: [io  0x4000-0x401f]
pci 0000:01:00.1: reg 1c: [mem 0x68280000-0x68283fff]
pci 0000:01:00.1: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0x68200000-0x682fffff]
pci 0000:02:00.0: [1000:0056] type 00 class 0x010000
pci 0000:02:00.0: reg 10: [io  0x3000-0x30ff]
pci 0000:02:00.0: reg 14: [mem 0x68110000-0x68113fff 64bit]
pci 0000:02:00.0: reg 1c: [mem 0x68100000-0x6810ffff 64bit]
pci 0000:02:00.0: reg 30: [mem 0xffe00000-0xffffffff pref]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:03.0: PCI bridge to [bus 02]
pci 0000:00:03.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:03.0:   bridge window [mem 0x68100000-0x681fffff]
pci 0000:00:04.0: PCI bridge to [bus 03]
pci 0000:00:05.0: PCI bridge to [bus 04]
pci 0000:05:00.0: [10de:0a60] type 00 class 0x030000
pci 0000:05:00.0: reg 10: [mem 0x62000000-0x62ffffff]
pci 0000:05:00.0: reg 14: [mem 0x50000000-0x5fffffff 64bit pref]
pci 0000:05:00.0: reg 1c: [mem 0x60000000-0x61ffffff 64bit pref]
pci 0000:05:00.0: reg 24: [io  0x2000-0x207f]
pci 0000:05:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
pci 0000:05:00.0: Boot video device
pci 0000:05:00.1: [10de:0be3] type 00 class 0x040300
pci 0000:05:00.1: reg 10: [mem 0x63000000-0x63003fff]
pci 0000:00:07.0: PCI bridge to [bus 05]
pci 0000:00:07.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:07.0:   bridge window [mem 0x50000000-0x630fffff]
pci 0000:00:1c.0: PCI bridge to [bus 06]
pci 0000:00:1c.1: PCI bridge to [bus 07]
pci 0000:00:1c.2: PCI bridge to [bus 08]
pci 0000:00:1c.3: PCI bridge to [bus 09]
pci 0000:0a:00.0: [18ca:0027] type 00 class 0x030000
pci 0000:0a:00.0: reg 10: [mem 0x64000000-0x67ffffff pref]
pci 0000:0a:00.0: reg 14: [mem 0x68000000-0x6803ffff]
pci 0000:0a:00.0: reg 18: [io  0x1000-0x107f]
pci 0000:0a:00.0: supports D1 D2
pci 0000:00:1c.4: PCI bridge to [bus 0a]
pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.4:   bridge window [mem 0x64000000-0x680fffff]
pci 0000:00:1c.5: PCI bridge to [bus 0b]
pci 0000:00:1e.0: PCI bridge to [bus 0c] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x1000-0x8fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x50000000-0x7fffffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.MRP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.MRP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.MRP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.MRP5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.MRP7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.PEX5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD0.PCI0.IP2P._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
acpi_start_single_object: acpi_device PNP0A08:00, driver pci_root to start
acpi_bus_match_device: acpi_device PNP0A08:00, attached driver is pci_root
acpi_bus_match_device: attach driver for device PNP0C0E:00
acpi_bus_match_device: acpi_device PNP0C0E:00, attached driver is NULL
acpi_bus_match_device: attach driver for device ACPI0004:03
acpi_bus_match_device: acpi_device ACPI0004:03, attached driver is NULL
acpi_bus_match_device: attach driver for device ACPI0004:04
acpi_bus_match_device: acpi_device ACPI0004:04, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:10
acpi_bus_match_device: acpi_device LNXCPU:10, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:11
acpi_bus_match_device: acpi_device LNXCPU:11, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:12
acpi_bus_match_device: acpi_device LNXCPU:12, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:13
acpi_bus_match_device: acpi_device LNXCPU:13, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:14
acpi_bus_match_device: acpi_device LNXCPU:14, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:15
acpi_bus_match_device: acpi_device LNXCPU:15, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:16
acpi_bus_match_device: acpi_device LNXCPU:16, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:17
acpi_bus_match_device: acpi_device LNXCPU:17, attached driver is NULL
acpi_bus_match_device: attach driver for device PNP0C80:02
acpi_bus_match_device: acpi_device PNP0C80:02, attached driver is NULL
acpi_bus_match_device: attach driver for device ACPI0004:05
acpi_bus_match_device: acpi_device ACPI0004:05, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:18
acpi_bus_match_device: acpi_device LNXCPU:18, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:19
acpi_bus_match_device: acpi_device LNXCPU:19, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:1a
acpi_bus_match_device: acpi_device LNXCPU:1a, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:1b
acpi_bus_match_device: acpi_device LNXCPU:1b, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:1c
acpi_bus_match_device: acpi_device LNXCPU:1c, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:1d
acpi_bus_match_device: acpi_device LNXCPU:1d, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:1e
acpi_bus_match_device: acpi_device LNXCPU:1e, attached driver is NULL
acpi_bus_match_device: attach driver for device LNXCPU:1f
acpi_bus_match_device: acpi_device LNXCPU:1f, attached driver is NULL
acpi_bus_match_device: attach driver for device PNP0C80:03
acpi_bus_match_device: acpi_device PNP0C80:03, attached driver is NULL
acpi_bus_match_device: attach driver for device PNP0A08:01
acpi_bus_match: device PNP0A08:01 find match driver pci_root
ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 40-7f])
pci_root PNP0A08:01: host bridge window [io  0x9000-0xfffe]
pci_root PNP0A08:01: host bridge window [mem 0x80000000-0x9fffffff]
PCI host bridge to bus 0000:40
pci_bus 0000:40: root bus resource [bus 40-7f]
pci_bus 0000:40: root bus resource [io  0x9000-0xfffe]
pci_bus 0000:40: root bus resource [mem 0x80000000-0x9fffffff]
pci 0000:40:00.0: [8086:3420] type 01 class 0x060400
pci 0000:40:00.0: PME# supported from D0 D3hot D3cold
pci 0000:40:01.0: [8086:3408] type 01 class 0x060400
pci 0000:40:01.0: PME# supported from D0 D3hot D3cold
pci 0000:40:03.0: [8086:340a] type 01 class 0x060400
pci 0000:40:03.0: PME# supported from D0 D3hot D3cold
pci 0000:40:04.0: [8086:340b] type 01 class 0x060400
pci 0000:40:04.0: PME# supported from D0 D3hot D3cold
pci 0000:40:05.0: [8086:340c] type 01 class 0x060400
pci 0000:40:05.0: PME# supported from D0 D3hot D3cold
pci 0000:40:07.0: [8086:340e] type 01 class 0x060400
pci 0000:40:07.0: PME# supported from D0 D3hot D3cold
pci 0000:40:0d.0: [8086:343a] type 00 class 0x060000
pci 0000:40:0d.1: [8086:343b] type 00 class 0x060000
pci 0000:40:0d.2: [8086:343c] type 00 class 0x060000
pci 0000:40:0d.3: [8086:343d] type 00 class 0x060000
pci 0000:40:0d.4: [8086:3418] type 00 class 0x060000
pci 0000:40:0d.5: [8086:3419] type 00 class 0x060000
pci 0000:40:0d.6: [8086:341a] type 00 class 0x060000
pci 0000:40:0d.7: [8086:341b] type 00 class 0x060000
pci 0000:40:0e.0: [8086:341c] type 00 class 0x060000
pci 0000:40:0e.1: [8086:341d] type 00 class 0x060000
pci 0000:40:0e.2: [8086:341e] type 00 class 0x060000
pci 0000:40:0e.3: [8086:341f] type 00 class 0x060000
pci 0000:40:0e.4: [8086:3439] type 00 class 0x060000
pci 0000:40:0f.0: [8086:3424] type 00 class 0x110100
pci 0000:40:10.0: [8086:3425] type 00 class 0x080000
pci 0000:40:10.1: [8086:3426] type 00 class 0x080000
pci 0000:40:11.0: [8086:3427] type 00 class 0x080000
pci 0000:40:11.1: [8086:3428] type 00 class 0x080000
pci 0000:40:13.0: [8086:342d] type 00 class 0x080020
pci 0000:40:13.0: reg 10: [mem 0x80220000-0x80220fff]
pci 0000:40:13.0: PME# supported from D0 D3hot D3cold
pci 0000:40:14.0: [8086:342e] type 00 class 0x080000
pci 0000:40:14.1: [8086:3422] type 00 class 0x080000
pci 0000:40:14.2: [8086:3423] type 00 class 0x080000
pci 0000:40:14.3: [8086:3438] type 00 class 0x080000
pci 0000:40:15.0: [8086:342f] type 00 class 0x080020
pci 0000:40:16.0: [8086:3430] type 00 class 0x088000
pci 0000:40:16.0: reg 10: [mem 0x80200000-0x80203fff 64bit]
pci 0000:40:16.1: [8086:3431] type 00 class 0x088000
pci 0000:40:16.1: reg 10: [mem 0x80204000-0x80207fff 64bit]
pci 0000:40:16.2: [8086:3432] type 00 class 0x088000
pci 0000:40:16.2: reg 10: [mem 0x80208000-0x8020bfff 64bit]
pci 0000:40:16.3: [8086:3433] type 00 class 0x088000
pci 0000:40:16.3: reg 10: [mem 0x8020c000-0x8020ffff 64bit]
pci 0000:40:16.4: [8086:3429] type 00 class 0x088000
pci 0000:40:16.4: reg 10: [mem 0x80210000-0x80213fff 64bit]
pci 0000:40:16.5: [8086:342a] type 00 class 0x088000
pci 0000:40:16.5: reg 10: [mem 0x80214000-0x80217fff 64bit]
pci 0000:40:16.6: [8086:342b] type 00 class 0x088000
pci 0000:40:16.6: reg 10: [mem 0x80218000-0x8021bfff 64bit]
pci 0000:40:16.7: [8086:342c] type 00 class 0x088000
pci 0000:40:16.7: reg 10: [mem 0x8021c000-0x8021ffff 64bit]
pci 0000:40:00.0: PCI bridge to [bus 41]
pci 0000:42:00.0: [8086:10c9] type 00 class 0x020000
pci 0000:42:00.0: reg 10: [mem 0x80160000-0x8017ffff]
pci 0000:42:00.0: reg 14: [mem 0x80140000-0x8015ffff]
pci 0000:42:00.0: reg 18: [io  0xe020-0xe03f]
pci 0000:42:00.0: reg 1c: [mem 0x80184000-0x80187fff]
pci 0000:42:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:42:00.0: PME# supported from D0 D3hot D3cold
pci 0000:42:00.1: [8086:10c9] type 00 class 0x020000
pci 0000:42:00.1: reg 10: [mem 0x80120000-0x8013ffff]
pci 0000:42:00.1: reg 14: [mem 0x80100000-0x8011ffff]
pci 0000:42:00.1: reg 18: [io  0xe000-0xe01f]
pci 0000:42:00.1: reg 1c: [mem 0x80180000-0x80183fff]
pci 0000:42:00.1: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:42:00.1: PME# supported from D0 D3hot D3cold
pci 0000:40:01.0: PCI bridge to [bus 42]
pci 0000:40:01.0:   bridge window [io  0xe000-0xefff]
pci 0000:40:01.0:   bridge window [mem 0x80100000-0x801fffff]
pci 0000:43:00.0: [1000:0056] type 00 class 0x010000
pci 0000:43:00.0: reg 10: [io  0xc000-0xc0ff]
pci 0000:43:00.0: reg 14: [mem 0x80010000-0x80013fff 64bit]
pci 0000:43:00.0: reg 1c: [mem 0x80000000-0x8000ffff 64bit]
pci 0000:43:00.0: reg 30: [mem 0xffe00000-0xffffffff pref]
pci 0000:43:00.0: supports D1 D2
pci 0000:43:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:40:03.0: PCI bridge to [bus 43]
pci 0000:40:03.0:   bridge window [io  0xc000-0xdfff]
pci 0000:40:03.0:   bridge window [mem 0x80000000-0x800fffff]
pci 0000:40:04.0: PCI bridge to [bus 44]
pci 0000:40:04.0:   bridge window [io  0xb000-0xbfff]
pci 0000:40:05.0: PCI bridge to [bus 45]
pci 0000:40:05.0:   bridge window [io  0xa000-0xafff]
pci 0000:40:07.0: PCI bridge to [bus 46]
pci 0000:40:07.0:   bridge window [io  0x9000-0x9fff]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD1.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD1.PCI1.MRP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD1.PCI1.MRP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD1.PCI1.MRP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD1.PCI1.MRP5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.NOD1.PCI1.MRP7._PRT]
 pci0000:40: Requesting ACPI _OSC control (0x1d)
 pci0000:40: ACPI _OSC control (0x1d) granted
acpi_start_single_object: acpi_device PNP0A08:01, driver pci_root to start
acpi_bus_match_device: acpi_device PNP0A08:01, attached driver is pci_root
acpi_bus_match_device: attach driver for device device:50
acpi_bus_match_device: acpi_device device:50, attached driver is NULL
ACPI: No dock devices found.
acpi_bus_match: device PNP0C0F:00 find match driver pci_link
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 *6 7 9 10 11 12 14 15)
acpi_bus_match: device PNP0C0F:01 find match driver pci_link
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
acpi_bus_match: device PNP0C0F:02 find match driver pci_link
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
acpi_bus_match: device PNP0C0F:03 find match driver pci_link
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
acpi_bus_match: device PNP0C0F:04 find match driver pci_link
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
acpi_bus_match: device PNP0C0F:05 find match driver pci_link
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
acpi_bus_match: device PNP0C0F:06 find match driver pci_link
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
acpi_bus_match: device PNP0C0F:07 find match driver pci_link
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
acpi root: \_SB_.NOD0.PCI0 notify handler is installed
acpi root: \_SB_.NOD1.PCI1 notify handler is installed
acpi root: \_SB_.NOD2.PCI2 notify handler is installed
acpi root: \_SB_.NOD3.PCI3 notify handler is installed
Found 4 acpi root devices

================================================================================IOH hot-add dmesg log===================================
ACPI: ACPI device name is <\_SB_.NOD1.PCI1>, event code is <1>
ACPI: Notify event is queued
_handle_hotplug_event_root: Device check notify on \_SB_.NOD1.PCI1
handle_root_bridge_insertion: hot add acpi_device for acpi_handle 31655c8
acpi_bus_scan: start 0
acpi_bus_check_add: acpi_device PNP0A08:02 added, add_type 1
acpi_bus_check_add: acpi_device ACPI0009:02 added, add_type 1
acpi_bus_check_add: acpi_device device:51 added, add_type 1
acpi_bus_check_add: acpi_device device:52 added, add_type 1
acpi_bus_check_add: acpi_device device:53 added, add_type 1
acpi_bus_check_add: acpi_device device:54 added, add_type 1
acpi_bus_check_add: acpi_device device:55 added, add_type 1
acpi_bus_check_add: acpi_device device:56 added, add_type 1
acpi_bus_check_add: acpi_device device:57 added, add_type 1
acpi_bus_check_add: acpi_device device:58 added, add_type 1
acpi_bus_check_add: acpi_device device:59 added, add_type 1
acpi_bus_check_add: acpi_device device:5a added, add_type 1
acpi_bus_check_add: acpi_device device:5b added, add_type 1
acpi_bus_check_add: acpi_device device:5c added, add_type 1
acpi_bus_check_add: acpi_device device:5d added, add_type 1
acpi_bus_check_add: acpi_device device:5e added, add_type 1
acpi_bus_check_add: acpi_device device:5f added, add_type 1
acpi_bus_check_add: acpi_device device:60 added, add_type 1
acpi_bus_check_add: acpi_device device:61 added, add_type 1
acpi_bus_check_add: acpi_device device:62 added, add_type 1
acpi_bus_check_add: acpi_device device:63 added, add_type 1
acpi_bus_check_add: acpi_device device:64 added, add_type 1
acpi_bus_check_add: acpi_device device:65 added, add_type 1
acpi_bus_check_add: acpi_device device:66 added, add_type 1
acpi_bus_check_add: acpi_device device:67 added, add_type 1
acpi_bus_check_add: acpi_device device:68 added, add_type 1
acpi_bus_check_add: acpi_device device:69 added, add_type 1
acpi_bus_check_add: acpi_device device:6a added, add_type 1
acpi_bus_check_add: acpi_device device:6b added, add_type 1
acpi_bus_match_device: attach driver for device ACPI0009:02 <====================== bus match for PNP0A08:02 missing
acpi_bus_match_device: acpi_device ACPI0009:02, attached driver is NULL
acpi_bus_match_device: attach driver for device device:51
acpi_bus_match_device: acpi_device device:51, attached driver is NULL
acpi_bus_match_device: attach driver for device device:52
acpi_bus_match_device: acpi_device device:52, attached driver is NULL
acpi_bus_match_device: attach driver for device device:53
acpi_bus_match_device: acpi_device device:53, attached driver is NULL
acpi_bus_match_device: attach driver for device device:54
acpi_bus_match_device: acpi_device device:54, attached driver is NULL
acpi_bus_match_device: attach driver for device device:55
acpi_bus_match_device: acpi_device device:55, attached driver is NULL
acpi_bus_match_device: attach driver for device device:56
acpi_bus_match_device: acpi_device device:56, attached driver is NULL
acpi_bus_match_device: attach driver for device device:57
acpi_bus_match_device: acpi_device device:57, attached driver is NULL
acpi_bus_match_device: attach driver for device device:58
acpi_bus_match_device: acpi_device device:58, attached driver is NULL
acpi_bus_match_device: attach driver for device device:59
acpi_bus_match_device: acpi_device device:59, attached driver is NULL
acpi_bus_match_device: attach driver for device device:5a
acpi_bus_match_device: acpi_device device:5a, attached driver is NULL
acpi_bus_match_device: attach driver for device device:5b
acpi_bus_match_device: acpi_device device:5b, attached driver is NULL
acpi_bus_match_device: attach driver for device device:5c
acpi_bus_match_device: acpi_device device:5c, attached driver is NULL
acpi_bus_match_device: attach driver for device device:5d
acpi_bus_match_device: acpi_device device:5d, attached driver is NULL
acpi_bus_match_device: attach driver for device device:5e
acpi_bus_match_device: acpi_device device:5e, attached driver is NULL
acpi_bus_match_device: attach driver for device device:5f
acpi_bus_match_device: acpi_device device:5f, attached driver is NULL
acpi_bus_match_device: attach driver for device device:60
acpi_bus_match_device: acpi_device device:60, attached driver is NULL
acpi_bus_match_device: attach driver for device device:61
acpi_bus_match_device: acpi_device device:61, attached driver is NULL
acpi_bus_match_device: attach driver for device device:62
acpi_bus_match_device: acpi_device device:62, attached driver is NULL
acpi_bus_match_device: attach driver for device device:63
acpi_bus_match_device: acpi_device device:63, attached driver is NULL
acpi_bus_match_device: attach driver for device device:64
acpi_bus_match_device: acpi_device device:64, attached driver is NULL
acpi_bus_match_device: attach driver for device device:65
acpi_bus_match_device: acpi_device device:65, attached driver is NULL
acpi_bus_match_device: attach driver for device device:66
acpi_bus_match_device: acpi_device device:66, attached driver is NULL
acpi_bus_match_device: attach driver for device device:67
acpi_bus_match_device: acpi_device device:67, attached driver is NULL
acpi_bus_match_device: attach driver for device device:68
acpi_bus_match_device: acpi_device device:68, attached driver is NULL
acpi_bus_match_device: attach driver for device device:69
acpi_bus_match_device: acpi_device device:69, attached driver is NULL
acpi_bus_match_device: attach driver for device device:6a
acpi_bus_match_device: acpi_device device:6a, attached driver is NULL
acpi_bus_match_device: attach driver for device device:6b
acpi_bus_match_device: acpi_device device:6b, attached driver is NULL
acpi_bus_start: acpi_device PNP0A08:02
acpi_bus_start_device: acpi_device ACPI0009:02      <====================== bus start for PNP0A08:02 missing,so pci_root driver won't be called
acpi_bus_start_device: acpi_device device:51
acpi_bus_start_device: acpi_device device:52
acpi_bus_start_device: acpi_device device:53
acpi_bus_start_device: acpi_device device:54
acpi_bus_start_device: acpi_device device:55
acpi_bus_start_device: acpi_device device:56
acpi_bus_start_device: acpi_device device:57
acpi_bus_start_device: acpi_device device:58
acpi_bus_start_device: acpi_device device:59
acpi_bus_start_device: acpi_device device:5a
acpi_bus_start_device: acpi_device device:5b
acpi_bus_start_device: acpi_device device:5c
acpi_bus_start_device: acpi_device device:5d
acpi_bus_start_device: acpi_device device:5e
acpi_bus_start_device: acpi_device device:5f
acpi_bus_start_device: acpi_device device:60
acpi_bus_start_device: acpi_device device:61
acpi_bus_start_device: acpi_device device:62
acpi_bus_start_device: acpi_device device:63
acpi_bus_start_device: acpi_device device:64
acpi_bus_start_device: acpi_device device:65
acpi_bus_start_device: acpi_device device:66
acpi_bus_start_device: acpi_device device:67
acpi_bus_start_device: acpi_device device:68
acpi_bus_start_device: acpi_device device:69
acpi_bus_start_device: acpi_device device:6a
acpi_bus_start_device: acpi_device device:6b


-- 
Thanks!
Yijing

