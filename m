Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0EJShK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:37:10 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:46256 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab0EJShF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:37:05 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432P98dN936eM62a3L7cf0izz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L27VPH-01-3EI-02
X-M-MSG: 
Date: Mon, 10 May 2010 20:36:54 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       Roland McGrath <roland@redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip] perf probe: Don't compile CFI related code if
 elfutils is old
Message-ID: <20100510183654.GH6450@erda.amd.com>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
 <20100510172854.GD30926@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100510172854.GD30926@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.05.10 13:28:54, Arnaldo Carvalho de Melo wrote:
> Em Mon, May 10, 2010 at 01:12:07PM -0400, Masami Hiramatsu escreveu:
> > Check elfutils version, and if it is old don't compile
> > CFI analysis code. This allows to compile perf with
> > old elfutils.
> 
> _ELFUTILS_PREREQ was introduced in:
> 
> commit fbc7245df72ce0142f0a21fa0f4f88c97278bf60
> Author: Roland McGrath <roland@redhat.com>
> Date:   Tue Dec 16 17:03:03 2008 -0800
> 
> Which was released in elfutils 0.138, guess this is coverage enough?
> Richard, which version is in your machine?

Right, this does not work, I am using 0.131. As expected,
"_ELFUTILS_PREREQ" is not defined:

gcc -o builtin-probe.o -c -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement  -fstack-protector-all -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include -Iarch/x86/include -I/usr/include/elfutils -DDWARF_SUPPORT -DNO_NEWT_SUPPORT -DNO_LIBPERL -DSHA1_HEADER='<openssl/sha.h>'  builtin-probe.c
In file included from builtin-probe.c:43:
util/probe-finder.h:47:5: error: "_ELFUTILS_PREREQ" is not defined
util/probe-finder.h:47:21: error: missing binary operator before token "("
make: *** [builtin-probe.o] Error 1

Why not create a compile test as for NO_DWARF in tools/perf/Makefile?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

