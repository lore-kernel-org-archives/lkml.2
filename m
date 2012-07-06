Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2GFNbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:31:10 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:39229 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab2GFNbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:31:08 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk3M7oE7o=
X-RZG-CLASS-ID: mo00
Date: Fri, 6 Jul 2012 15:31:05 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120706133105.GA20600@aepfle.de>
References: <20120705210607.GA26908@aepfle.de>
 <20120706084120.GA31219@router-fw-old.local.net-space.pl>
 <20120706120750.GA8970@aepfle.de>
 <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, Jan Beulich wrote:

> >>> On 06.07.12 at 14:07, Olaf Hering <olaf@aepfle.de> wrote:
> > But adding some debug to inspect
> > *output in parse_elf() shows that the second entry in program headers is
> > already shifted by 44 bytes in my testing, the others are shifted by the
> > same amount.
> 
> Unfortunately it's not clear what is shifted - the printout below
> looks just fine. Also, from your first mail I understood that the shift
> there was by an amount not divisible by 4 - does that amount vary?

The memory location of the second LOAD entry (the .data section) is wrong.
It should be at 0x1c00000, but in fact its content starts at 0x1c0002c.
I looked at the x86 boot code, the vmlinux is gzipped and placed as
binary blob, which is then extracted by decompress().

I will cleanup my debug changes and post the output.

Olaf

> > Program Headers:
> >   Type           Offset   VirtAddr           PhysAddr           FileSiz  
> > MemSiz   Flg Align
> >   LOAD           0x200000 0xffffffff81000000 0x0000000001000000 0xa3b000 
> > 0xa3b000 R E 0x200000
> >   LOAD           0xe00000 0xffffffff81c00000 0x0000000001c00000 0x05b0e8 
> > 0x05b0e8 RW  0x200000
> >   LOAD           0x1000000 0x0000000000000000 0x0000000001c5c000 0x012c40 
> > 0x012c40 RW  0x200000
> >   LOAD           0x106f000 0xffffffff81c6f000 0x0000000001c6f000 0x087000 
> > 0x702000 RWE 0x200000
> >   NOTE           0x82d5bc 0xffffffff8162d5bc 0x000000000162d5bc 0x00017c 
> > 0x00017c     0x4
