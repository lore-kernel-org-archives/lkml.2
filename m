Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab0JXMuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 08:50:09 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:53334 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab0JXMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 08:50:07 -0400
Date: Sun, 24 Oct 2010 13:50:04 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Corentin Chary <corentincj@iksaif.net>
Subject: Re: EeePC 900 reboots/hangs when using using perf -a -f -g
Message-ID: <20101024125003.GA3323@sucs.org>
References: <20100912102854.GA7359@sucs.org> <1284289027.2251.95.camel@laptop> <20100912112105.GA28420@sucs.org> <20100912124653.GA5342@nowhere> <20100912162141.GB30698@sucs.org> <20100917030125.GA5389@nowhere> <20100921172711.GA31352@sucs.org> <20101002210314.GA5373@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101002210314.GA5373@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Sorry I'm not quite sure how I missed your reply - I've only just
noticed it:

On Sat, Oct 02, 2010 at 11:03:17PM +0200, Frederic Weisbecker wrote:
> 
> I've been unable to reproduce with your config in latest tip:/perf/core,
> I haven't tested in a eeepc though.
> 
> Did you check with 2.6.36-rc4 or with a tip branch?

I was checking with 2.6.36-rc4. I have just checked again with a recent
tip:/perf/core (66a301c380d4e463424db572b348de4913ec191a) and the
problem can still be reliably triggered.

I've narrowed the steps to cause the problem too. Running
perf record -a -f -g "sleep 5s"
and then doing
echo 0 > /sys/class/backlight/eeepc/brightness
will reliably trigger the problem (on this EeePC 900 the brightness
controls are provided by the eeepc-laptop driver).

One other thing to note is that I am building perf on a Fedora 12 system
and running the binary on an Ubuntu 10.04 system. I build perf
statically and at the during compilation the following is printed:
$ LDFLAGS=-static make
Makefile:568: newt not found, disables TUI support. Please install newt-devel or libnewt-dev
[...]
    LINK perf
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libpthread.a(libpthread.o): In function `sem_open':
(.text+0x6afa): warning: the use of `mktemp' is dangerous, better use `mkstemp'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwarf_getcfi.o): In function `dwarf_getcfi':
(.text+0xbf): undefined reference to `elf_getident'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module.o): In function `__libdwfl_module_free':
(.text+0x143): undefined reference to `ebl_closebackend'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(offline.o): In function `process_file':
(.text+0x7c): undefined reference to `elf_getarhdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(offline.o): In function `process_file':
(.text+0x161): undefined reference to `elf_next'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(offline.o): In function `process_file':
(.text+0x1ec): undefined reference to `elf_next'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(offline.o): In function `process_file':
(.text+0x2b9): undefined reference to `elf_cntl'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x170): undefined reference to `elf_getphdrnum'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x1c9): undefined reference to `gelf_getphdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x1fe): undefined reference to `elf_getdata_rawchunk'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x2b4): undefined reference to `gelf_getdyn'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x365): undefined reference to `gelf_getphdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x48e): undefined reference to `elf_getdata_rawchunk'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x55c): undefined reference to `elf_getdata_rawchunk'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x598): undefined reference to `elf_getdata_rawchunk'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x657): undefined reference to `elf_getdata_rawchunk'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x695): undefined reference to `gelf_getclass'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x6f6): undefined reference to `elf_getdata_rawchunk'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_dynsym':
(.text+0x7e1): undefined reference to `elf_getdata_rawchunk'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `__libdwfl_getelf':
(.text+0xa1a): undefined reference to `elf_getphdrnum'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `__libdwfl_getelf':
(.text+0xa5e): undefined reference to `gelf_getphdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `__libdwfl_module_getebl':
(.text+0xddd): undefined reference to `ebl_openbackend'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_debuginfo':
(.text+0xe53): undefined reference to `elf_getshdrstrndx'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_debuginfo':
(.text+0xfaa): undefined reference to `elf_getphdrnum'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_debuginfo':
(.text+0xfee): undefined reference to `gelf_getphdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `find_debuginfo':
(.text+0x1227): undefined reference to `gelf_xlatetom'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `load_dw':
(.text+0x15df): undefined reference to `elf_cntl'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_getdwarf.o): In function `load_dw':
(.text+0x1600): undefined reference to `elf_cntl'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(open.o): In function `what_kind':
(.text+0xcd): undefined reference to `elf_memory'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(gzip.o): In function `__libdw_gunzip':
(.text+0x219): undefined reference to `gzdopen'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(gzip.o): In function `__libdw_gunzip':
(.text+0x22e): undefined reference to `gzdirect'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(gzip.o): In function `__libdw_gunzip':
(.text+0x281): undefined reference to `gzread'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(gzip.o): In function `__libdw_gunzip':
(.text+0x30f): undefined reference to `gzerror'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(gzip.o): In function `__libdw_gunzip':
(.text+0x31a): undefined reference to `gzclose'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(gzip.o): In function `__libdw_gunzip':
(.text+0x337): undefined reference to `gzclose'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(gzip.o): In function `__libdw_gunzip':
(.text+0x37a): undefined reference to `gzclose'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(gzip.o): In function `__libdw_gunzip':
(.text+0x467): undefined reference to `gzclose'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(bzip2.o): In function `__libdw_bunzip2':
(.text+0x1bf): undefined reference to `BZ2_bzDecompressInit'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(bzip2.o): In function `__libdw_bunzip2':
(.text+0x227): undefined reference to `BZ2_bzDecompressEnd'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(bzip2.o): In function `__libdw_bunzip2':
(.text+0x2ac): undefined reference to `BZ2_bzDecompress'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(bzip2.o): In function `__libdw_bunzip2':
(.text+0x2e0): undefined reference to `BZ2_bzDecompressEnd'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(bzip2.o): In function `__libdw_bunzip2':
(.text+0x394): undefined reference to `BZ2_bzDecompressEnd'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(lzma.o): In function `__libdw_unlzma':
(.text+0x1c0): undefined reference to `lzma_auto_decoder'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(lzma.o): In function `__libdw_unlzma':
(.text+0x232): undefined reference to `lzma_end'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(lzma.o): In function `__libdw_unlzma':
(.text+0x2ec): undefined reference to `lzma_code'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(lzma.o): In function `__libdw_unlzma':
(.text+0x31e): undefined reference to `lzma_end'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(lzma.o): In function `__libdw_unlzma':
(.text+0x44a): undefined reference to `lzma_end'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(cfi.o): In function `__libdw_frame_at_address':
(.text+0x1c8d): undefined reference to `ebl_abi_cfi'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(cfi.o): In function `__libdw_frame_at_address':
(.text+0x1de1): undefined reference to `ebl_openbackend'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_report_elf.o): In function `__libdwfl_report_elf':
(.text+0x9a): undefined reference to `elf_getphdrnum'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_report_elf.o): In function `__libdwfl_report_elf':
(.text+0xf0): undefined reference to `gelf_getphdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_report_elf.o): In function `__libdwfl_report_elf':
(.text+0x1af): undefined reference to `gelf_getphdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_report_elf.o): In function `__libdwfl_report_elf':
(.text+0x44b): undefined reference to `gelf_update_shdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_report_elf.o): In function `__libdwfl_report_elf':
(.text+0xa5e): undefined reference to `gelf_update_shdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `__libdwfl_relocate_value':
(.text+0x7a): undefined reference to `elf_getshdrstrndx'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `__libdwfl_relocate_value':
(.text+0x107): undefined reference to `gelf_update_shdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate.7048':
(.text+0x200): undefined reference to `ebl_reloc_simple_type'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate.7048':
(.text+0x3c1): undefined reference to `gelf_xlatetof'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate.7048':
(.text+0x4b8): undefined reference to `gelf_getsymshndx'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate.7048':
(.text+0x5c3): undefined reference to `gelf_getsymshndx'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate.7048':
(.text+0x703): undefined reference to `gelf_xlatetom'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate_section':
(.text+0xc2b): undefined reference to `ebl_get_elfmachine'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate_section':
(.text+0xc87): undefined reference to `gelf_update_rela'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate_section':
(.text+0xd36): undefined reference to `ebl_debugscn_p'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate_section':
(.text+0xdbe): undefined reference to `ebl_get_elfmachine'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate_section':
(.text+0xe20): undefined reference to `gelf_update_rel'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate_section':
(.text+0xe73): undefined reference to `gelf_update_shdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate_section':
(.text+0xf08): undefined reference to `gelf_update_rela'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `relocate_section':
(.text+0xf85): undefined reference to `gelf_update_rel'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `__libdwfl_relocate_section':
(.text+0x102c): undefined reference to `elf_getshdrstrndx'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(relocate.o): In function `__libdwfl_relocate':
(.text+0x114f): undefined reference to `elf_getshdrstrndx'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_build_id.o): In function `check_notes':
(.text+0x3d): undefined reference to `gelf_getnote'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_build_id.o): In function `__libdwfl_find_build_id':
(.text+0x294): undefined reference to `elf_ndxscn'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_build_id.o): In function `__libdwfl_find_build_id':
(.text+0x2ea): undefined reference to `elf_getphdrnum'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_build_id.o): In function `__libdwfl_find_build_id':
(.text+0x328): undefined reference to `gelf_getphdr'
/usr/lib/gcc/i686-redhat-linux/4.4.4/../../../libdw.a(dwfl_module_build_id.o): In function `__libdwfl_find_build_id':
(.text+0x380): undefined reference to `elf_getdata_rawchunk'
collect2: ld returned 1 exit status
make: *** [perf] Error 1

Which is strange as RPM reports the following:

$ rpm -qa *elf* | sort
elfutils-0.148-1.fc12.i686
elfutils-devel-0.148-1.fc12.i686
elfutils-devel-static-0.148-1.fc12.i686
elfutils-libelf-0.148-1.fc12.i686
elfutils-libelf-devel-0.148-1.fc12.i686
elfutils-libelf-devel-static-0.148-1.fc12.i686
elfutils-libs-0.148-1.fc12.i686

So I build a dynamically linked perf.

-- 
Sitsofe | http://sucs.org/~sits/
