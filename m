Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab0FGQ7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:59:42 -0400
Received: from clueserver.org ([65.102.45.174]:45202 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0FGQ7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 12:59:40 -0400
Subject: Re: Additional info on modpost segfault
From: Alan <alan@clueserver.org>
To: Michal Marek <mmarek@suse.cz>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C08A9D0.8000505@suse.cz>
References: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>
	 <20100604045118.GC5167@cr0.nay.redhat.com>  <4C08A9D0.8000505@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 09:59:39 -0700
Message-ID: <1275929979.2923.0.camel@zowie.clueserver.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 09:22 +0200, Michal Marek wrote: 
> On 4.6.2010 06:51, Américo Wang wrote:
> > On Thu, Jun 03, 2010 at 08:10:30PM -0700, alan wrote:
> >> Missed adding the actual segfault message:
> >>
> >>  LD      drivers/usb/built-in.o
> >>  LD      drivers/built-in.o
> >>  LD      vmlinux.o
> >>  MODPOST vmlinux.o
> >> /bin/sh: line 1: 20665 Segmentation fault      (core dumped)
> >> scripts/mod/modpost -o
> >> /home/alan/GitTrees/linux-2.6-mid-ref/Module.symvers -S vmlinux.o
> >> make[1]: *** [vmlinux.o] Error 139
> >> make: *** [vmlinux.o] Error 2
> >>
> >> I have looked at the gcc 4.4.4 changelog and I can't see anything
> >> that should cause this.
> >>
> > 
> > Hmm, you need to find which program segfaults here.
> 
> It's the modpost command run on vmlinux.o. Alan, can you try
> $ gdb --args scripts/mod/modpost -o Module.symvers -S vmlinux.o
> (gdb) r
> (wait for the segfault)
> (gdb) bt full
> 
> and post the backtrace?

Don't know if this will help much.

This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols
from /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost...(no
debugging symbols found)...done.
(gdb) r
Starting
program: /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost -o
Module.symvers -S vmlinux.o

Program received signal SIGSEGV, Segmentation fault.
0x0000000000403711 in main ()
(gdb) bt full
#0  0x0000000000403711 in main ()
No symbol table info available.

Trying to get it to compile with debugging info.



