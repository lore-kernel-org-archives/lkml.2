Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0FIIcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:32:04 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:54620 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab0FIIcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:32:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=V+2BQ7pw6O2ScekqRwxqXAey1IbTnEWe1GJhWsRXprMVTAOvP8PlCiEXaihstYUnfv
         IC962L+tIpyWeNboibgvvlOSurENiTD49tvgny6CJmK0vKQzwaYndw2aVmrkT7cwq4Wb
         hvFem9ansun431l8xDRnI9oADC+m5v6CS1iZ8=
Date: Wed, 9 Jun 2010 16:35:59 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alan <alan@clueserver.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Additional info on modpost segfault
Message-ID: <20100609083559.GC5875@cr0.nay.redhat.com>
References: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>
 <20100604045118.GC5167@cr0.nay.redhat.com>
 <4C08A9D0.8000505@suse.cz>
 <1275929979.2923.0.camel@zowie.clueserver.org>
 <20100608055152.GA7110@cr0.nay.redhat.com>
 <1276021458.14066.3.camel@zowie.clueserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276021458.14066.3.camel@zowie.clueserver.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 11:24:18AM -0700, Alan wrote:
>On Tue, 2010-06-08 at 13:51 +0800, Américo Wang wrote: 
>> On Mon, Jun 07, 2010 at 09:59:39AM -0700, Alan wrote:
>> >On Fri, 2010-06-04 at 09:22 +0200, Michal Marek wrote: 
>> >> On 4.6.2010 06:51, Américo Wang wrote:
>> >> > On Thu, Jun 03, 2010 at 08:10:30PM -0700, alan wrote:
>> >> >> Missed adding the actual segfault message:
>> >> >>
>> >> >>  LD      drivers/usb/built-in.o
>> >> >>  LD      drivers/built-in.o
>> >> >>  LD      vmlinux.o
>> >> >>  MODPOST vmlinux.o
>> >> >> /bin/sh: line 1: 20665 Segmentation fault      (core dumped)
>> >> >> scripts/mod/modpost -o
>> >> >> /home/alan/GitTrees/linux-2.6-mid-ref/Module.symvers -S vmlinux.o
>> >> >> make[1]: *** [vmlinux.o] Error 139
>> >> >> make: *** [vmlinux.o] Error 2
>> >> >>
>> >> >> I have looked at the gcc 4.4.4 changelog and I can't see anything
>> >> >> that should cause this.
>> >> >>
>> >> > 
>> >> > Hmm, you need to find which program segfaults here.
>> >> 
>> >> It's the modpost command run on vmlinux.o. Alan, can you try
>> >> $ gdb --args scripts/mod/modpost -o Module.symvers -S vmlinux.o
>> >> (gdb) r
>> >> (wait for the segfault)
>> >> (gdb) bt full
>> >> 
>> >> and post the backtrace?
>> >
>> >Don't know if this will help much.
>> >
>> >This GDB was configured as "x86_64-redhat-linux-gnu".
>> >For bug reporting instructions, please see:
>> ><http://www.gnu.org/software/gdb/bugs/>...
>> >Reading symbols
>> >from /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost...(no
>> >debugging symbols found)...done.
>> >(gdb) r
>> >Starting
>> >program: /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost -o
>> >Module.symvers -S vmlinux.o
>> >
>> >Program received signal SIGSEGV, Segmentation fault.
>> >0x0000000000403711 in main ()
>> >(gdb) bt full
>> >#0  0x0000000000403711 in main ()
>> >No symbol table info available.
>> >
>> >Trying to get it to compile with debugging info.
>> >
>> 
>> Try to append "-g" to HOSTCFLAGS in the top Makefile. ;)
>
>Thanks. Tried CFLAGS and that did not work...
>
>Here is the backtrace:
>(gdb) bt full
>#0  read_symbols (argc=5, argv=0x7fffffffe198) at
>scripts/mod/modpost.c:1564
>        license = <value optimized out>
>        info = {size = 209695023, hdr = 0x7fffeb263000, 
>          sechdrs = 0x7ffff48fcc2c, symtab_start = 0x7ffff7863e2c, 
>          symtab_stop = 0x7ffff794341c, export_sec = 37, 
>          export_unused_sec = 0, export_gpl_sec = 48, 
>          export_unused_gpl_sec = 0, export_gpl_future_sec = 0, 
>          strtab = 0x7ffff794341c "", modinfo = 0x0, modinfo_len = 0}
>        sym = <value optimized out>
>        symname = <value optimized out>
>        version = <value optimized out>
>        mod = 0x610010
>#1  main (argc=5, argv=0x7fffffffe198) at scripts/mod/modpost.c:1999
>        mod = <value optimized out>
>        buf = {p = 0x0, pos = 0, size = 0}
>        kernel_read = <value optimized out>
>        module_read = <value optimized out>
>        dump_write = 0x7fffffffe4ed "Module.symvers"
>        opt = <value optimized out>
>        err = <value optimized out>
>        extsym_iter = <value optimized out>
>        extsym_start = <value optimized out>
>
>The line is does not like is:
>
>  read_symbols(argv[optind++]);
>
>Not certain why...

Hmm, it seems the segfault happens at 'license = get_modinfo(...)'?
I can't spot any bug around that.

If I were you, I would do a step by step debug with gdb.

Thanks!
