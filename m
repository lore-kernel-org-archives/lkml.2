Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894Ab2FGOZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:25:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34611 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760760Ab2FGOZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:25:03 -0400
Date: Thu, 7 Jun 2012 16:24:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rus <rus@sfinxsoft.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.[34].x Reproducable [Firmware bug] message upon warm boot only
Message-ID: <20120607142459.GB5053@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Rus <rus@sfinxsoft.com>,
	linux-kernel@vger.kernel.org
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
 <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 04:40:01PM +0300, Rus wrote:
> Hello,
> 
> I have the following reproducable message upon each 3.4.1 warm boot :
> 
> ....
> [Firmware Bug]: cpu 0, invalid threshold interrupt offset 0 for bank
> 4, block 0 (MSR00000413=0xc010000001000000)
> [Firmware Bug]: cpu 0, invalid threshold interrupt offset 0 for bank
> 4, block 1 (MSRC0000408=0xc010000001000000)
> [Firmware Bug]: cpu 0, invalid threshold interrupt offset 0 for bank
> 4, block 2 (MSRC0000409=0xc01001c001000000)
> .....
> [Firmware Bug]: cpu 7, try to use APIC500 (LVT offset 0) for vector
> 0x10400, but the register is already in use for vector 0xf9 on another
> cpu
> [Firmware Bug]: cpu 7, IBS interrupt offset 0 not available
> (MSRC001103A=0x0000000000000100)
> Failed to setup IBS, -22
> .....
> 
> Cold boot do not show this message. The hardware is Asus M5A97 PRO
> (latest 1208 Bios) and FX-8150 CPU, 24GB RAM, the only system on this
> box is Linux.

Can you send /proc/cpuinfo from that box?

> Is this message harmless or this is some problem with hardware/bios/Linux ?

Mostly harmless, fix is already upstream: f227d306cf3 and also on its
way to stable. You can try 3.5-rc1 on the box (it should be pretty
stable on AMD) or wait for the stable backport.

Thanks.

-- 
Regards/Gruss,
Boris.
