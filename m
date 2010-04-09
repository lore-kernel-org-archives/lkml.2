Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab0DIQEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:04:45 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8528 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0DIQEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:04:43 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well as x86_32
Date: Fri, 9 Apr 2010 10:04:39 -0600
User-Agent: KMail/1.9.10
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-pci@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>
References: <20100407210628.28364.96982.stgit@bob.kio> <201004071705.07176.bjorn.helgaas@hp.com> <4BBD13C3.2060404@oracle.com>
In-Reply-To: <4BBD13C3.2060404@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004091004.39857.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 April 2010 05:22:43 pm Yinghai wrote:
> On 04/07/2010 04:05 PM, Bjorn Helgaas wrote:
> > On Wednesday 07 April 2010 04:45:30 pm Yinghai wrote:
> >> On 04/07/2010 02:06 PM, Bjorn Helgaas wrote:
> >>>
> >>> Currently, we only reserve the legacy VGA area [mem 0xa0000-0xbffff] on
> >>> x86_32.  But this legacy area is also used on x86_64, so this patch
> >>> reserves it there, too.
> >>>
> >>> If we don't reserve it, we may mistakenly move a PCI device to that area,
> >>> as we did here:
> >>>
> >>>   pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
> >>>   pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
> >>>   pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
> >>>   pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]
> >>>
> >>> as reported by Andy Isaacson at http://lkml.org/lkml/2010/4/6/375
> >>>
> >>> I think the fact that the BAR is not within a host bridge window is a
> >>> BIOS defect, and it's now more visible because we have "pci=use_crs" as
> >>> the default.  Using "pci=nocrs" is a workaround, because then we won't
> >>> attempt to move the device.
> >>
> >> that doesn't look right.
> >>
> >> It seem another thread, erission has one model without VGA, and they use that area for other device MMIO.
> >>
> >> current for 64bit, We remove [0xa0000, 0x100000) from e820 map if those area is E820_RAM.
> >>
> >> in e820_reserve_resources(), kernel will reserve range < 1M according to e820 map.
> >> that is before pci BAR is claimed.
> >>
> >> or you can add
> >> boot_params.screen_info.orig_video_isVGA == 1
> >> or double check scan pci tree to see if video is there or not
> > 
> > I'm sorry, I can't understand what you're saying.
> 
> for 64 bit, you may check boot_params.screen_info.orig_video_isVGA to see if you need to reserve that VGA range.
> not sure if every bootloader fill that...

Why is this different for 64-bit vs 32-bit?  Can you point me to any
references where I can learn about this?

Bjorn
