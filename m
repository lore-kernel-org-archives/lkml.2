Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0GAQPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:15:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50193 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0GAQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:15:37 -0400
Date: Thu, 1 Jul 2010 18:17:38 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/21] perf: rewire generic library stuff, p1
Message-ID: <20100701161738.GH17823@aftab>
References: <1277992175-19821-1-git-send-email-bp@amd64.org>
 <1277992175-19821-6-git-send-email-bp@amd64.org>
 <20100701154737.GE8902@ghostprotocols.net>
 <20100701161054.GF8902@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100701161054.GF8902@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, Jul 01, 2010 at 12:10:54PM -0400

Hi Arnaldo,

> Em Thu, Jul 01, 2010 at 12:47:37PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Thu, Jul 01, 2010 at 03:49:19PM +0200, Borislav Petkov escreveu:
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > Carve out generic library stuff into tools/lib/lk/ and rewire it with
> > > perf. Add a top-level Makefile which selects between targets depending
> > > on the tool we want to build. Also, add a Makefile.lib for common
> > > facilities used by all the Makefiles.
> > 
> > Testing this now, thanks,
> 
> Needs the patch below for "make O=~/build/perf tools" to continue
> working. Needs some more polishing so as not to break the non O= case.
> 
> After lunch will investigate why my usual way to build the tools isn't working
> anymore, some missing -I probably:
> 
> [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/perf install
> make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
>     CC /home/acme/git/build/perf/builtin-record.o
> builtin-record.c:24:23: error: lk/cpumap.h: No such file or directory
> cc1: warnings being treated as errors
> builtin-record.c: In function ‘__cmd_record’:
> builtin-record.c:622: error: implicit declaration of function ‘read_cpu_map’
> builtin-record.c:632: error: ‘cpumap’ undeclared (first use in this function)
> builtin-record.c:632: error: (Each undeclared identifier is reported only once
> builtin-record.c:632: error: for each function it appears in.)
> make: *** [/home/acme/git/build/perf/builtin-record.o] Error 1
> make: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
> [acme@emilia linux-2.6-tip]$
> 
> diff --git a/tools/lib/Makefile b/tools/lib/Makefile
> index 48f8e21..814673e 100644
> --- a/tools/lib/Makefile
> +++ b/tools/lib/Makefile
> @@ -5,6 +5,9 @@ LIB_H =
>  LIB_OBJS =
>  
>  LIB_H += lk/cpumap.h
> +OUTPUT := $(OUTPUT)/lib/
> +
> +$(shell sh -c 'mkdir -p $(OUTPUT)/lk' 2> /dev/null)
>  
>  LIB_OBJS += $(OUTPUT)lk/bitmap.o
>  LIB_OBJS += $(OUTPUT)lk/cpumap.o

I'll fix that up, thanks for testing.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
