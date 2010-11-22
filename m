Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab0KVX0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:26:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34026 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab0KVX0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:26:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A5oTnxrtKWDG38SHSuGkNknJg753OsRbAPCS0lr2mvndimUGmuiVvhyTlZfg4uGGb1
         9h69LY1Ldswm85cxUUvFJNTThSvc2CHOygNoN2wUg4vOE6Jq6KplV8aW3fhjeexlVmZ4
         NCgXo93ZA9E6PuIAITXlpie7LXKQa3ff5Pdb8=
MIME-Version: 1.0
In-Reply-To: <icbqak$32o$1@ID-44327.news.uni-berlin.de>
References: <icbqak$32o$1@ID-44327.news.uni-berlin.de>
Date: Mon, 22 Nov 2010 15:26:39 -0800
X-Google-Sender-Auth: rfZ9n-xyECxcoWRM5uTGS8xJ71I
Message-ID: <AANLkTingmPcKU25knD1s4WE31Zj2Y+dBr=GW-0OLejs_@mail.gmail.com>
Subject: Re: missing 700 MB of RAM
From: Yinghai Lu <yinghai@kernel.org>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 11:02 AM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Hello,
>
> I've got 8 GB RAM installed, but linux reports 7,3 GB. Where is the
> missing RAM (700 MB)?
>
> free
>             total       used       free     shared    buffers     cached
> Mem:       7706580    5271096    2435484          0      79232    3049120
> -/+ buffers/cache:    2142744    5563836
> Swap:      8393956          0    8393956
>
> The motherboard is a GA-MA78GM-S2H (64bit, AMD) with a on board Radeon
> HD 3200 VGA card. The card uses 256 MB of RAM - so 444 MB of RAM are
> missing. Where are they gone?
>
>
> kernel: 2.6.34.7-33-desktop (OpenSuSE 11.3)
>
> dmesg
> Linux version 2.6.34.7-33-desktop (geeko@buildhost) (gcc version 4.4.1
> [gcc-4_4-branch revision 150839] (SUSE Linux) ) #1 SMP PREEMPT
> 2010-11-09 20:08:44 +0100
> Command line:
> root=/dev/disk/by-id/scsi-SATA_WDC_WD5000AACS-_WD-WCAUF1158341-part1
> splash=silent quiet nmi_watchdog=0 iommu=noagp,memaper=0 agp=off vga=0x376
> BIOS-provided physical RAM map:
> BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 00000000afde0000 (usable)
> BIOS-e820: 00000000afde0000 - 00000000afde3000 (ACPI NVS)
> BIOS-e820: 00000000afde3000 - 00000000afdf0000 (ACPI data)
> BIOS-e820: 00000000afdf0000 - 00000000afe00000 (reserved)
> BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
...
> 01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200
> Graphics (prog-if 00 [VGA controller])
>        Subsystem: Giga-byte Technology GA-MA78GM-S2H Motherboard
>        Flags: bus master, fast devsel, latency 0, IRQ 18
>        Memory at d0000000 (32-bit, prefetchable) [size=256M]
>        I/O ports at ee00 [size=256]
>        Memory at fdfe0000 (32-bit, non-prefetchable) [size=64K]
>        Memory at fde00000 (32-bit, non-prefetchable) [size=1M]
>        Expansion ROM at <unassigned> [disabled]
>        Capabilities: [50] Power Management version 3
>        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>        Kernel driver in use: fglrx_pci

looks like
your BIOS only mmio remapping from 0xd000000 to 0x100000000
   because  last e820 entry and TOM2 is 0x230000000.

so you lose memory from 0xb0000000 to 0xd0000000. that 512M?

check with your system vendor to get a BIOS update...

Yinghai
