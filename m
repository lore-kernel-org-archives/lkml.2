Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1GOPdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:33:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54071 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1GOPdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:33:03 -0400
Date: Fri, 15 Jul 2011 17:32:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, peterz@infradead.org, paulus@samba.org
Subject: Re: [PATCH] perf tools, x86: fix 32-bit compile on 64-bit system
Message-ID: <20110715153253.GA6590@somewhere>
References: <1310420304-21452-1-git-send-email-dsahern@gmail.com>
 <4E205C58.30607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E205C58.30607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 09:27:20AM -0600, David Ahern wrote:
> On 07/11/2011 03:38 PM, David Ahern wrote:
> > Builds for 32-bit binaries on a 64-bit host currently fail with the error:
> > 
> > gcc -o /tmp/perf-ppc/bench/mem-memcpy-x86-64-asm.o -c -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement -m32 -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include -Iarch/x86/include -I/tmp/perf-ppc/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_NEWT_SUPPORT -DNO_LIBPERL -DNO_LIBPYTHON -DHAVE_CPLUS_DEMANGLE -DNO_STRLCPY -DARCH_X86_64 bench/mem-memcpy-x86-64-asm.S
> > bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
> > bench/../../../arch/x86/lib/memcpy_64.S:29: Error: bad register name `%rdi'
> > bench/../../../arch/x86/lib/memcpy_64.S:34: Error: invalid instruction suffix for `movs'
> > bench/../../../arch/x86/lib/memcpy_64.S:50: Error: bad register name `%rdi'
> > bench/../../../arch/x86/lib/memcpy_64.S:61: Error: bad register name `%rdi'
> > ...
> > 
> > The problem is the detection of the host arch without considering passed in
> > flags. This change fixes 32-bit builds via:
> > 
> > make EXTRA_CFLAGS=-m32 
> > 
> > and 64-bit builds still reference the memcpy_64.S.
> > 
> 
> Fairly trivial change to the Makefile. Any objections? I believe Arnaldo
> is out for a few more days and realistically another week to get through
> a month's backlog.
> 
> David

Yeah, looks good.

Thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
