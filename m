Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2CXBWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:22:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab2CXBWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:22:30 -0400
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
Date: Sat, 24 Mar 2012 02:22:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, hpa@zytor.com
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <CAE9FiQVFd=Zef2bH_3MinLEV_V+cEShrmRTe7Sr8HT2R46yHHw@mail.gmail.com> <CAE9FiQX8hfD6o_UZxR-pLEZ631G+D5odP3MmVOZ=MN2AFPJ+Lw@mail.gmail.com>
In-Reply-To: <CAE9FiQX8hfD6o_UZxR-pLEZ631G+D5odP3MmVOZ=MN2AFPJ+Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201203240222.27165.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 March 2012 02:05:18 Yinghai Lu wrote:
> On Fri, Mar 23, 2012 at 1:54 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Fri, Mar 23, 2012 at 7:29 AM, Thomas Renninger <trenn@suse.de> wrote:
> >> Details can be found in:
> >> Documentation/acpi/initrd_table_override.txt
> >>
> >> Additional dmesg output of a booted system with
> >> FACP (FADT), DSDT and SSDT (the 9th dynamically loaded one)
> >> tables overridden (with ### marked comments):
> >>
> >> ### ACPI tables found glued to initrd
> >> DSDT ACPI table found in initrd - size: 16234
> >> FACP ACPI table found in initrd - size: 116
> >> SSDT ACPI table found in initrd - size: 334
> >> ### Re-printed e820 map via e820_update() with additionally created
> >> ### ACPI data section at 0xcff55000 where the ACPI tables passed via
> >> ### initrd where copied to
> >> modified physical RAM map:
> >> ...
> >>  ### New ACPI data section:
> >>  modified: 00000000cff55000 - 00000000cff5912c (ACPI data)
> >>  ### BIOS e820 provided ACPI data section:
> >>  modified: 00000000cff60000 - 00000000cff69000 (ACPI data)
> >> ...
> >> ### Total size of all ACPI tables glued to initrd
> >> ### The address is initrd_start which gets updated to
> >> ### initrd_start = initrd_start + "size of all ACPI tables glued to initrd"
> >> Found acpi tables of size: 16684 at 0xffff8800374c4000
> >>
> >> Disabling lock debugging due to kernel taint
> >> ### initrd provided FACP and DSDT tables are used instead of BIOS provided ones
> >> ACPI: FACP @ 0x00000000cff68dd8 Phys table override, replaced with:
> >> ACPI: FACP 00000000cff58f6a 00074 (v01 INTEL  TUMWATER 06040000 PTL  00000003)
> >> ACPI: DSDT @ 0x00000000cff649d4 Phys table override, replaced with:
> >> ACPI: DSDT 00000000cff55000 04404 (v01  Intel BLAKFORD 06040000 MSFT 0100000E)
> >> ...
> >> ### Much later, the 9th (/sys/firmware/acpi/table/dynamic/SSDT9) dynamically
> >> ### loaded ACPI table matches and gets overridden:
> >> ACPI: SSDT @ 0x00000000cff64824 Phys table override, replaced with:
> >> ACPI: SSDT 00000000cff58fde 0014E (v01  PmRef  Cpu7Ist 00003000 INTL 20110316)
> >> ACPI: Dynamic OEM Table Load:
> >> ACPI: SSDT           (null) 0014E (v01  PmRef  Cpu7Ist 00003000 INTL 20110316)
> >> ...
> >>
> >> If the initrd does not start with a valid ACPI table signature or the ACPI
> >> table's checksum is wrong, there is no functional change.
> 
> updated it a little bit to remove 2 #ifdef. please check attached.

Plus getting rid of the e820 stuff in drivers/acpi/osl.c
Thanks, nice cleanups.

   Thomas
