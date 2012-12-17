Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2LQHOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 02:14:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:5243 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab2LQHOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 02:14:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,299,1355126400"; 
   d="scan'208";a="258219188"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
Thread-Topic: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
Thread-Index: AQHN27U5Cxm9cfLkVkqEiPpUYGHzQJgcPMCAgAA+0YCAAB9DAP//gCswgACSdoCAABZUAP//0B0A
Date: Mon, 17 Dec 2012 07:14:44 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220470F8338@ORSMSX105.amr.corp.intel.com>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
	<1355654609-16800-9-git-send-email-fenghua.yu@intel.com>
	<CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
	<50CE4097.2020104@zytor.com>
	<CAE9FiQXmz07SUEwJdr0QD8Y2Uro6Sizkeg4KfFkJSuQLFW3Fow@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F81EE@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQUqJVJ6JSeGzFH+OtRA4syrbXZh-RJLSghvB8fdBt97oQ@mail.gmail.com>
 <CAE9FiQXqXh9OQvu2a-atm3Ydhi+LOLw1pLJ-tCavmSnAohXmkQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXqXh9OQvu2a-atm3Ydhi+LOLw1pLJ-tCavmSnAohXmkQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Sunday, December 16, 2012 6:02 PM
> To: Yu, Fenghua
> Cc: H. Peter Anvin; Ingo Molnar; Thomas Gleixner; Mallick, Asit K;
> Tigran Aivazian; Andreas Herrmann; Borislav Petkov; linux-kernel; x86
> Subject: Re: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-
> bit
> 
> On Sun, Dec 16, 2012 at 4:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Sun, Dec 16, 2012 at 3:59 PM, Yu, Fenghua <fenghua.yu@intel.com>
> wrote:
> >>
> >>> it has to be rebased after #PF handler version. otherwise it can
> not
> >>> handle for framdisk that is loaded after 1G.
> >>>
> >>> Fenghua,
> >>>
> >>> can you post your boot log with 64bit with your patch?
> >>>
> >>> Yinghai
> >>
> >> Attached is dmesg with the patches.
> >>
> >
> > yes, your laptop only have 1G ram, and
> >
> > [    0.000000] e820: BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff]
> usable
> > [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003e6affff]
> usable
> > [    0.000000] BIOS-e820: [mem 0x000000003e6b0000-0x000000003e6ccfff]
> ACPI data
> > [    0.000000] BIOS-e820: [mem 0x000000003e6cd000-0x000000003e6fffff]
> ACPI NVS
> > [    0.000000] BIOS-e820: [mem 0x000000003e700000-0x000000003effffff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff]
> reserved
> > [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff]
> reserved
> >
> > ramdisk is at
> >      RAMDISK: [mem 0x27608000-0x2fafbfff]
> >
> > and current kernel default set 1G to kernel mapping. so it happens to
> > work with your patchset.
> >
> > please find one sytem with 4G or more to test it.
> >
> > and you may need to rebase your patches on top of my for-x86-boot
> > branch with working #PF handler set page table patch.
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-
> yinghai.gi
> > t
> > for-x86-boot
> 
> also you did not consider initrd relocating....
> 
> please check attached fix, and see if you can fold in into you next
> posting.
> 
> Thanks
> 
> Yinghai

Your fix is based on old v2 patchset.

Today's v3 patchset fixes this issue already. Basically it uses offset instead of pointer in initrd image and converts offset to pointer when it accesses the microcode in initrd image. It uses pointers after boot time. 

Thanks.

-Fenghua
