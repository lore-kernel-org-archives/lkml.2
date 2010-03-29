Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0C2Pvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab0C2Pvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:51:43 -0400
Message-ID: <4BB0CC60.8010604@redhat.com>
Date: Mon, 29 Mar 2010 11:50:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, probe-finder: Build fix on Debian
References: <20100329154132.GA16223@aftab>
In-Reply-To: <20100329154132.GA16223@aftab>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Building chokes with
> 
> In file included from /usr/include/gelf.h:53,
>                  from /usr/include/elfutils/libdw.h:53,
>                  from util/probe-finder.h:61,
>                  from util/probe-finder.c:39:
> /usr/include/libelf.h:98: error: expected specifier-qualifier-list before 'off64_t'
> /usr/include/libelf.h:160: error: expected specifier-qualifier-list before 'off64_t'
> /usr/include/libelf.h:201: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'elf_update'
> /usr/include/libelf.h:207: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'elf_getbase'
> /usr/include/libelf.h:305: error: expected declaration specifiers or '...' before 'off64_t'
> /usr/include/libelf.h:317: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'elf_getaroff'
> make: *** [util/probe-finder.o] Error 1
> make: *** Waiting for unfinished jobs....
> rm .perf.dev.null
> 
> which is due to the fact that </usr/include/libelf.h> isn't seeing
> off64_t from <sys/types.h>
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Thank you for fixing it :)

However, all library checking routine in Makefile use
"-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64", so I think
it is better to add these flags to ALL_CFLAGS.

Thank you,


> ---
> 
> This happens on current -git: v2.6.34-rc2-288-gb72c409
> 
>  tools/perf/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 8a8f52d..19c34a5 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -508,7 +508,7 @@ ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; e
>  	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
>  	BASIC_CFLAGS += -DNO_DWARF_SUPPORT
>  else
> -	BASIC_CFLAGS += -I/usr/include/elfutils
> +	BASIC_CFLAGS += -I/usr/include/elfutils -D_LARGEFILE64_SOURCE
>  	EXTLIBS += -lelf -ldw
>  	LIB_OBJS += util/probe-finder.o
>  endif

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
