Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab1ENFPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 01:15:09 -0400
Received: from mx1.netlogicmicro.com ([12.203.210.36]:4529 "EHLO
	orion5.netlogicmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750815Ab1ENFPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 01:15:06 -0400
X-TM-IMSS-Message-ID: <52f81fd00004d258@netlogicmicro.com>
Date: Sat, 14 May 2011 10:43:04 +0530
From: "Jayachandran C." <jayachandranc@netlogicmicro.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
Message-ID: <20110514051303.GE14607@jayachandranc.netlogicmicro.com>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
 <20110513150707.GA26389@linux-mips.org>
 <BANLkTikcyEzjOWt9pWToE=89dySSEYbw_g@mail.gmail.com>
 <20110513155605.GA30674@linux-mips.org>
 <BANLkTinnALQV6dXkJ0AjaQ1=bTawYMMkuQ@mail.gmail.com>
 <20110513173633.GA14607@jayachandranc.netlogicmicro.com>
 <BANLkTim+z7TSCvNA2duA6LsUzNsiu9OQaQ@mail.gmail.com>
 <20110513184532.GC14607@jayachandranc.netlogicmicro.com>
 <BANLkTi=CJPuhO7OjCv5UF_ABQMb-bFe-2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=CJPuhO7OjCv5UF_ABQMb-bFe-2A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 May 2011 05:11:59.0540 (UTC) FILETIME=[73DC9F40:01CC11F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 03:06:35PM -0700, Kevin Cernekee wrote:
> On Fri, May 13, 2011 at 11:45 AM, Jayachandran C.
> <jayachandranc@netlogicmicro.com> wrote:
> > The current linux-mips queue works for me, and I don't have the old source
> > or binaries with me anymore. You surely should be able build with
> > nlm_xlr_defconfig and see if the rixi is enabled in the build, if you want
> > any config register dump on the CPU, please let me know.
> 
> I was able to locate an old MIPS R5000 based system and get linux-mips
> queue running on it.  Here are the settings:
> 
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_64BIT_PHYS_ADDR=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_SYS_SUPPORTS_32BIT_KERNEL=y
> CONFIG_CPU_SUPPORTS_32BIT_KERNEL=y
> CONFIG_SYS_SUPPORTS_64BIT_KERNEL=y
> CONFIG_CPU_SUPPORTS_64BIT_KERNEL=y
> CONFIG_32BIT=y
> # CONFIG_64BIT is not set
> CONFIG_SMP=y
> 
> This was intended to mimic the XLR configuration: 32-bit kernel on a
> 64-bit CPU with 64-bit physical addressing, SMP (albeit with 1 CPU),
> no RI/XI.
> 
> After applying all 4 of my page cleanup patches, the system still
> booted and ran normally.
> 
> Userspace is glibc with a bash shell (also tried uClibc w/bash, same
> result).  Since the reported assertion appeared to be in bash.
> 
> Jayachandran - how do you think we should debug this?  It seems like
> the problem only shows up on XLR.  Since this is a relatively new
> platform, is it possible that something else might be broken still?

Can you send me the patchset which works on top of queue with any
debugging you want enabled?  I can try that and send you the results.

It is also possible that something is broken with the XLR platform code,
it is currently almost straight r4k...

Thanks,
JC.
