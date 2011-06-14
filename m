Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1FNMLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab1FNMLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:11:10 -0400
Date: Tue, 14 Jun 2011 08:11:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
Message-ID: <20110614121102.GT3765@redhat.com>
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com>
 <20110613145012.GA1924@redhat.com>
 <4DF700AF.3090702@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF700AF.3090702@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 02:33:19PM +0800, Chen Gong wrote:
> >Using an Intel box I have over at RedHat, I was able to use this patch to
> >get error injection (EINJ) to provide me a GHES record.  Prior to this
> >patch I would just get unknown NMIs.
> >
> >Talking with Matthew Garret, I guess it seems that uuids like this are
> >typical for ACPI.
> >
> >I can't speak for all the ACPI parts, but the patch looks simple and
> >corret from my perspective.
> >
> Interesting, but I can't reproduce it on our machines by now. Would you
> please share your test information such as machine type, BIOS
> version, and test method (such as what type error you inject) ?

Sure,

#cat /proc/cpuinfo

processor       : 23
vendor_id       : GenuineIntel
cpu family      : 6
model           : 44
model name      : Intel(R) Xeon(R) CPU           X5670  @ 2.93GHz
stepping        : 2
cpu MHz         : 1596.000

#dmidecode

Handle 0x0002, DMI type 1, 27 bytes
System Information
        Manufacturer: Intel Corporation
        Product Name: S5520UR
        Version: ....................
        Serial Number: ............
        UUID: 57890342-6DA6-11DF-BD83-001517EE9AE8
        Wake-up Type: AC Power Restored
        SKU Number: Not Specified
        Family: Not Specified

Handle 0x0003, DMI type 2, 16 bytes
Base Board Information
        Manufacturer: Intel Corporation
        Product Name: S5520UR
        Version: E81084-751
        Serial Number: BZUB02211743
        Asset Tag: ....................
        Features:
                Board is a hosting board
                Board is replaceable
        Location In Chassis: Not Specified
        Chassis Handle: 0x0004
        Type: Motherboard
        Contained Object Handles: 0

Handle 0x0005, DMI type 0, 24 bytes
BIOS Information
        Vendor: Intel Corp.
        Version: S5500.86B.01.00.0055.112620101923
        Release Date: 11/26/2010
        Address: 0xF0000
        Runtime Size: 64 kB
        ROM Size: 8192 kB
        Characteristics:
                PCI is supported
                PNP is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                Boot from CD is supported
                Selectable boot is supported
                EDD is supported
                3.5"/2.88 MB floppy services are supported (int 13h)
                Print screen service is supported (int 5h)
                8042 keyboard services are supported (int 9h)
:
                CGA/mono video services are supported (int 10h)
                ACPI is supported
                USB legacy is supported
                LS-120 boot is supported
                ATAPI Zip drive boot is supported
                Function key-initiated network boot is supported
                Targeted content distribution is supported
        BIOS Revision: 17.18
        Firmware Revision: 0.0

#instructions
mount -t debugfs debugfs /sys/kernel/debug
cd /sys/kernel/debug/apei/einj
echo 0x20 > error_type
echo 1 > error_inject
#should fail within one second

Let me know if you need more info.
By the way this is the only machine where this works.  Other Intel
machines stopped producing NMIs when their BIOS was updated (before I got
the chance to validate this patch on them).

Cheers,
Don

