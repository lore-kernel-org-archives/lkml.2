Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0KBRFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:05:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35048 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0KBRFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:05:00 -0400
Date: Tue, 2 Nov 2010 18:03:35 +0100
From: Borislav Petkov <bp@amd64.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: AMD boot freeze bisected to
 b126b4703afa4010b161784a43650337676dd03b
Message-ID: <20101102170335.GC24927@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

I am testing 37-rc1 on a quad-socket MCM system (48 cores) and it
freezes during boot with the messages below:

...
[    5.590748] pnp: PnP ACPI: found 14 devices
[    5.595386] ACPI: ACPI bus type pnp unregistered
[    5.600412] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    5.607422] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    5.614772] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    5.621773] system 00:01: [mem 0xc8000000-0xc8007fff] could not be reserved
[    5.629129] system 00:08: [io  0x0220-0x022f] has been reserved
[    5.635432] system 00:08: [io  0x040b] has been reserved
[    5.641125] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    5.647427] system 00:08: [io  0x04d6] has been reserved
[    5.653123] system 00:08: [io  0x0530-0x0537] has been reserved
[    5.659433] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    5.665742] system 00:08: [io  0x0c14] has been reserved
[    5.671439] system 00:08: [io  0x0c50-0x0c52] has been reserved
[    5.677744] system 00:08: [io  0x0c6c] has been reserved
[    5.683438] system 00:08: [io  0x0c6f] has been reserved
[    5.689134] system 00:08: [io  0x0ca0-0x0caf] has been reserved
[    5.695434] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    5.701744] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    5.708055] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    5.714364] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    5.720664] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    5.726965] system 00:08: [io  0x2000-0x205f] has been reserved
[    5.733268] system 00:08: [io  0x2100-0x21ff window] has been reserved
[    5.740184] system 00:08: [io  0x2200-0x22ff window] has been reserved
[    5.747099] system 00:08: [io  0x0f40-0x0f47] has been reserved
[    5.753402] system 00:08: [io  0x087f] has been reserved
[    5.759101] system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
[    5.766100] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    5.773106] system 00:0d: [mem 0xd8000000-0xd8007fff] could not be reserved
[    5.802579] pci 0000:00:04.0: BAR 9: assigned [mem 0xc9e00000-0xc9ffffff pref]
[    5.810513] pci 0000:00:03.0: BAR 9: assigned [mem 0xc9d00000-0xc9dfffff pref]
[    5.818433] pci 0000:01:00.0: BAR 6: assigned [mem 0xc9dc0000-0xc9dfffff pref]
[    5.826354] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    5.831962] pci 0000:00:03.0:   bridge window [io  0x3000-0x3fff]
[    5.838446] pci 0000:00:03.0:   bridge window [mem 0xc8100000-0xc81fffff]
[    5.845624] pci 0000:00:03.0:   bridge window [mem 0xc9d00000-0xc9dfffff pref]
[    5.853547] pci 0000:02:00.0: BAR 6: assigned [mem 0xc9e00000-0xc9ffffff pref]
[    5.861465] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    5.867075] pci 0000:00:04.0:   bridge window [io  0x4000-0x4fff]
[    5.873558] pci 0000:00:04.0:   bridge window [mem 0xc8200000-0xc82fffff]
[    5.880732] pci 0000:00:04.0:   bridge window [mem 0xc9e00000-0xc9ffffff pref]
[    5.888649] pci 0000:00:09.0: PCI bridge to [bus 03-03]
[    5.894260] pci 0000:00:09.0:   bridge window [io  disabled]
[    5.900304] pci 0000:00:09.0:   bridge window [mem 0xca000000-0xcdffffff]
[    5.907480] pci 0000:00:09.0:   bridge window [mem pref disabled]
<EOF>




Bisecting the kernel gave the following results and reverting
b126b4703afa4010b161784a43650337676dd03b does really fix booting. Let me
know what info you'd need/patches tested for debugging this.

Thanks.

b126b4703afa4010b161784a43650337676dd03b is the first bad commit
commit b126b4703afa4010b161784a43650337676dd03b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Oct 26 15:41:39 2010 -0600

    PCI: allocate bus resources from the top down
    
    Allocate space from the highest-address PCI bus resource first, then work
    downward.
    
    Previously, we looked for space in PCI host bridge windows in the order
    we discovered the windows.  For example, given the following windows
    (discovered via an ACPI _CRS method):
    
        pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
        pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
        pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
        pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xf7ffffff]
        pci_root PNP0A03:00: host bridge window [mem 0xff980000-0xff980fff]
        pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
        pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
    
    we attempted to allocate from [mem 0x000a0000-0x000bffff] first, then
    [mem 0x000c0000-0x000effff], and so on.
    
    With this patch, we allocate from [mem 0xff980000-0xff980fff] first, then
    [mem 0xff97c000-0xff97ffff], [mem 0xfed20000-0xfed9ffff], etc.
    
    Allocating top-down follows Windows practice, so we're less likely to
    trip over BIOS defects in the _CRS description.
    
    On the machine above (a Dell T3500), the [mem 0xbff00000-0xbfffffff] region
    doesn't actually work and is likely a BIOS defect.  The symptom is that we
    move the AHCI controller to 0xbff00000, which leads to "Boot has failed,
    sleeping forever," a BUG in ahci_stop_engine(), or some other boot failure.
    
    Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c43
    Reference: https://bugzilla.redhat.com/show_bug.cgi?id=620313
    Reference: https://bugzilla.redhat.com/show_bug.cgi?id=629933
    Reported-by: Brian Bloniarz <phunge0@hotmail.com>
    Reported-and-tested-by: Stefan Becker <chemobejk@gmail.com>
    Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

:040000 040000 234ddafeeb942c78dbfc36825706c00cc5c9a06f a6beefdad2b794afd9ddef066664afa695afc5eb M      drivers

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
