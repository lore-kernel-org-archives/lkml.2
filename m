Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab0EGScA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:32:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757604Ab0EGSb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:31:59 -0400
Date: Fri, 7 May 2010 15:31:43 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf probe: Support DW_OP_call_frame_cfa in
	debuginfo
Message-ID: <20100507183143.GB30926@ghostprotocols.net>
References: <20100412171728.3790.98217.stgit@localhost6.localdomain6> <tip-a34a985499895a46a4dacff727d0fbc63cdc75e8@git.kernel.org> <20100507163321.GB15333@erda.amd.com> <4BE44AF4.3090303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BE44AF4.3090303@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 07, 2010 at 01:16:36PM -0400, Masami Hiramatsu escreveu:
> Hi,
> 
> Robert Richter wrote:
> > On 15.04.10 07:29:18, tip-bot for Masami Hiramatsu wrote:
> >> diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
> >> index 2a27132..310ce89 100644
> >> --- a/tools/perf/util/probe-finder.h
> >> +++ b/tools/perf/util/probe-finder.h
> >> @@ -42,6 +42,7 @@ struct probe_finder {
> >>  	struct list_head	lcache;		/* Line cache for lazy match */
> >>  
> >>  	/* For variable searching */
> >> +	Dwarf_CFI		*cfi;		/* Call Frame Information */
> > 
> > I get the following complile error:
> > 
> > gcc -o builtin-probe.o -c -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement  -fstack-protector-all -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include -I/usr/include/elfutils -DDWARF_SUPPORT -DNO_NEWT_SUPPORT -DNO_LIBPERL -DSHA1_HEADER='<openssl/sha.h>'  builtin-probe.c
> > In file included from builtin-probe.c:43:
> > util/probe-finder.h:45: error: expected specifier-qualifier-list before ‘Dwarf_CFI’
> > make: *** [builtin-probe.o] Error 1
> > build script error: 2
> > 
> > git grep only finds the following:
> > 
> >  $ git grep Dwarf_CFI 
> >  tools/perf/util/probe-finder.h: Dwarf_CFI               *cfi;           /* Call Frame Information */
> > 
> > Am I missing something?
> 
> Hmm, it seems that Dwarf_CFI is not defined in library.
> (it is defined as a type in /usr/include/elfutils/libdw.h)
> Could you tell me what version of elfutils you are using?

Masami-san,

	If we are version dependant on that, we should disable this
specific feature by doing one more compile test like we have for setting
NO_DWARF, hopefully just a subset of DWARF support can be disabled due
to this version dependency, right?

- Arnaldo
