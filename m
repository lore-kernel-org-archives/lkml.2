Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0EJS6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:58:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab0EJS5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:57:53 -0400
Message-ID: <4BE8571E.4020403@redhat.com>
Date: Mon, 10 May 2010 14:57:34 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       Roland McGrath <roland@redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip] perf probe: Don't compile CFI related code if elfutils
 is old
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6> <20100510172854.GD30926@ghostprotocols.net> <20100510183654.GH6450@erda.amd.com>
In-Reply-To: <20100510183654.GH6450@erda.amd.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> On 10.05.10 13:28:54, Arnaldo Carvalho de Melo wrote:
>> Em Mon, May 10, 2010 at 01:12:07PM -0400, Masami Hiramatsu escreveu:
>>> Check elfutils version, and if it is old don't compile
>>> CFI analysis code. This allows to compile perf with
>>> old elfutils.
>>
>> _ELFUTILS_PREREQ was introduced in:
>>
>> commit fbc7245df72ce0142f0a21fa0f4f88c97278bf60
>> Author: Roland McGrath <roland@redhat.com>
>> Date:   Tue Dec 16 17:03:03 2008 -0800
>>
>> Which was released in elfutils 0.138, guess this is coverage enough?
>> Richard, which version is in your machine?
> 
> Right, this does not work, I am using 0.131. As expected,
> "_ELFUTILS_PREREQ" is not defined:
> 
> gcc -o builtin-probe.o -c -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement  -fstack-protector-all -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include -Iarch/x86/include -I/usr/include/elfutils -DDWARF_SUPPORT -DNO_NEWT_SUPPORT -DNO_LIBPERL -DSHA1_HEADER='<openssl/sha.h>'  builtin-probe.c
> In file included from builtin-probe.c:43:
> util/probe-finder.h:47:5: error: "_ELFUTILS_PREREQ" is not defined
> util/probe-finder.h:47:21: error: missing binary operator before token "("
> make: *** [builtin-probe.o] Error 1
> 
> Why not create a compile test as for NO_DWARF in tools/perf/Makefile?

Hmm, ok, version.h is also introduced at the same time.

# git log ./config/version.h.in
commit fbc7245df72ce0142f0a21fa0f4f88c97278bf60
Author: Roland McGrath <roland@redhat.com>
Date:   Tue Dec 16 17:03:03 2008 -0800

    Install elfutils/version.h header for library compatibility checking.

So, I think we'd better set NO_DWARF if the elfutils
is older than 0.138, since we can't check API compatibility
easily.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
