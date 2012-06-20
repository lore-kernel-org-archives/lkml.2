Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2FTEAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 00:00:12 -0400
Received: from linux-sh.org ([111.68.239.195]:58361 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab2FTEAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 00:00:10 -0400
Date: Wed, 20 Jun 2012 12:59:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: Build regressions/improvements in v3.5-rc3
Message-ID: <20120620035951.GC5623@linux-sh.org>
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 09:56:59PM +0200, Geert Uytterhoeven wrote:
> On Sun, Jun 17, 2012 at 9:46 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > JFYI, when comparing v3.5-rc3 to v3.5-rc2[3], the summaries are:
> > ??- build errors: +235/-10
> 
> Truckloads of powerpc "Unrecognized opcode" breakage, and
> 
That was my fault, should be fixed up by 2603efa31a.

>   + drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: error: implicit
> declaration of function 'pci_iomap'
> [-Werror=implicit-function-declaration]:  => 90:3
>   + drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: error: implicit
> declaration of function 'pci_iounmap'
> [-Werror=implicit-function-declaration]:  => 142:2
> 
Not sure about this one, it should find everything alright via:

	linux/io.h -> asm/io.h -> asm-generic/iomap.h -> asm-generic/pci_iomap.h

in the case that PCI is enabled. None of allyesconfig/modconfig enable
PCI for me though, so I'm unsure of how you got in to this configuration
to begin with?

> xtensa
> 
>   + error: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!:  => N/A
>   + error: "__lshrdi3" [fs/ntfs/ntfs.ko] undefined!:  => N/A
> 
> sh4/landisk_defconfig
> 
>   + error: "__ashrdi3" [fs/xfs/xfs.ko] undefined!:  => N/A
>   + error: "__lshrdi3" [drivers/mtd/mtd.ko] undefined!:  => N/A
>   + error: "__lshrdi3" [fs/xfs/xfs.ko] undefined!:  => N/A
> 
These seem to be the same issue on both platforms, EXPORT_SYMBOL()
doesn't work from lib-y. While it's straightforward to fix, I'm not able
to reproduce __lshrdi3/__ashrdi3 references in any of the above, which
compiler are you using?
