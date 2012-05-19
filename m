Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063Ab2ESAkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:40:21 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:41982 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756318Ab2ESAkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:40:18 -0400
Message-ID: <4FB6EBF8.3000401@xenotime.net>
Date: Fri, 18 May 2012 17:40:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-3.3.6 compile errors...crypto? require ia32?
References: <4FB6D755.5000603@tlinx.org>
In-Reply-To: <4FB6D755.5000603@tlinx.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 04:12 PM, Linda Walsh wrote:

> I ran through 'gconfig' (xconfig kept crashing my Cygwin X server -- remote compile from win),
> on a 3.3.2 image... got some compile errors... wanted to make sure I had latest
> source and fresh tree, so pulled down 3.3.6, copied over my .config, and first ran
> make 'oldconfig'... (one new driver popped up, said 'no')... then did a make -j. Got some errors in compiling -- and was wondering what I might have done to cause them?
> 
> @ end is my .config.
> 
> (running x86-64 suse base, w/gcc 4.5)
> 
> 
> Seems that for some reason -- some of the modules are trying to include 32-bit calls
> vanilla kernel just downloaded.
> 
> I thought it might have something to do with intel specific crypto instructions,
> but they all say x64... so not sure..
> 
> Do intel crypto instructions require 32-bit sys calls?
> 


Hi Linda,

I don't know what the problem is here.  Your config builds
fine for me (no errors).


> 
> 
> 
> Ishtar:linux/ish-336> make clean
>  CLEAN   .
>  CLEAN   .tmp_versions
> Ishtar:linux/ish-336> make
> make[1]: Nothing to be done for `all'.
>  CHK     include/linux/version.h
>  CHK     include/generated/utsrelease.h
>  HOSTCC  scripts/basic/fixdep
>  CC      kernel/bounds.s
>  GEN     include/generated/bounds.h
>  CC      arch/x86/kernel/asm-offsets.s
>  GEN     include/generated/asm-offsets.h
>  CALL    scripts/checksyscalls.sh
>  HOSTCC  scripts/genksyms/genksyms.o
>  HOSTCC  scripts/genksyms/lex.lex.o
>  HOSTCC  scripts/genksyms/parse.tab.o
>  HOSTLD  scripts/genksyms/genksyms
>  CC      scripts/mod/empty.o
>  HOSTCC  scripts/mod/mk_elfconfig
>  MKELF   scripts/mod/elfconfig.h
>  HOSTCC  scripts/mod/file2alias.o
>  HOSTCC  scripts/mod/modpost.o
>  HOSTCC  scripts/mod/sumversion.o
>  HOSTLD  scripts/mod/modpost
>  HOSTCC  scripts/kallsyms
>  HOSTCC  scripts/pnmtologo
>  HOSTCC  scripts/conmakehash
>  HOSTCC  scripts/bin2c
>  CC      init/main.o
>  CHK     include/generated/compile.h
>  CC      init/version.o
>  CC      init/do_mounts.o
>  CC      init/do_mounts_rd.o
>  LD      init/mounts.o
>  CC      init/noinitramfs.o
>  CC      init/calibrate.o
>  LD      init/built-in.o
>  LD      usr/built-in.o
>  AS      arch/x86/crypto/aes-x86_64-asm_64.o
>  CC      arch/x86/crypto/aes_glue.o
>  AS      arch/x86/crypto/aesni-intel_asm.o
>  CC      arch/x86/crypto/aesni-intel_glue.o
>  CC      arch/x86/crypto/fpu.o
>  AS      arch/x86/crypto/twofish-x86_64-asm_64-3way.o
>  CC      arch/x86/crypto/twofish_glue_3way.o
>  AS      arch/x86/crypto/twofish-x86_64-asm_64.o
>  CC      arch/x86/crypto/twofish_glue.o
>  LD      arch/x86/crypto/aes-x86_64.o
>  LD      arch/x86/crypto/twofish-x86_64.o
>  LD      arch/x86/crypto/twofish-x86_64-3way.o
>  LD      arch/x86/crypto/aesni-intel.o
>  CC      arch/x86/crypto/crc32c-intel.o
>  LD      arch/x86/crypto/built-in.o
>  AS      arch/x86/ia32/ia32entry.o
>  CC      arch/x86/ia32/sys_ia32.o
>  CC      arch/x86/ia32/ia32_signal.o
> arch/x86/ia32/ia32_signal.c: In function ‘ia32_setup_frame’:
> arch/x86/ia32/ia32_signal.c:421:3: error: ‘__NR_ia32_sigreturn’ undeclared (first use in this function)
> arch/x86/ia32/ia32_signal.c:421:3: note: each undeclared identifier is reported only once for each function it appears in
> arch/x86/ia32/ia32_signal.c: In function ‘ia32_setup_rt_frame’:
> arch/x86/ia32/ia32_signal.c:500:3: error: ‘__NR_ia32_rt_sigreturn’ undeclared (first use in this function)
> make[2]: *** [arch/x86/ia32/ia32_signal.o] Error 1
> make[1]: *** [arch/x86/ia32] Error 2
> make: *** [arch/x86] Error 2



-- 
~Randy
