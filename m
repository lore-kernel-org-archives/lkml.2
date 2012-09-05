Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab2IEVv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:51:27 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:57285 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759656Ab2IEVv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:51:26 -0400
X-Greylist: delayed 1656 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2012 17:51:25 EDT
Message-ID: <1346880183.21985.90.camel@ted>
Subject: Re: [RFC PATCH] perf: add SLANG_INC for slang.h
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Liang Li <liang.li@windriver.com>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 05 Sep 2012 22:23:03 +0100
In-Reply-To: <20120905205439.GD8203@ghostprotocols.net>
References: <1345777839-15843-1-git-send-email-liang.li@windriver.com>
	 <20120905205439.GD8203@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 13:54 -0700, Arnaldo Carvalho de Melo wrote:
> Em Fri, Aug 24, 2012 at 11:10:39AM +0800, Liang Li escreveu:
> > CFLAGS was previously hard coded to contain "-I/usr/include/slang" to
> > work with hosts that have "/usr/include/slang/slang.h" as well as hosts
> > that have "/usr/include/slang.h". This path can cause compile warnings
> > like:
> > 
> > cc1: warning: '/usr/include/slang' doesn't exists.
> > 
> > or
> > 
> > cc1: warning: include location "/usr/include/slang" is unsafe for
> > cross-compilation [-Wpoison-system-directories]
> > 
> > Then in some cases warnings become errors if WERROR is enabled hence
> > build errors.
> > 
> > To fix this issue, we can use -idirafter to downgrade the priority of the
> > default hard coded path. We can also make the slang include directory
> > a variable, to allow the user to specify SLANG_INC and set their own
> > include location. And add a '=' prefix to indicate better
> > compatibility with sysroot/cross compile cases.
> 
>     CC /home/acme/git/build/perf/builtin-diff.o
> In file included from util/../ui/keysyms.h:4,
>                  from util/hist.h:142,
>                  from builtin-diff.c:11:
> util/../ui/libslang.h:12:19: error: slang.h: No such file or directory
> util/../ui/libslang.h:14:5: error: "SLANG_VERSION" is not defined
> In file included from util/../ui/keysyms.h:4,
>                  from util/hist.h:142,
>                  from util/evsel.h:10,
>                  from util/evlist.h:8,
>                  from builtin-annotate.c:20:
> util/../ui/libslang.h:12:19: error: slang.h: No such file or directory
> util/../ui/libslang.h:14:5: error: "SLANG_VERSION" is not defined
> builtin-annotate.c: In function ‘hists__find_annotations’:
> builtin-annotate.c:122: error: ‘SL_KEY_RIGHT’ undeclared (first use in
> this function)
> builtin-annotate.c:122: error: (Each undeclared identifier is reported
> only once
> builtin-annotate.c:122: error: for each function it appears in.)
> builtin-annotate.c:134: error: ‘SL_KEY_LEFT’ undeclared (first use in
> this function)
> make: *** [/home/acme/git/build/perf/builtin-annotate.o] Error 1
> make: *** Waiting for unfinished jobs....
> make: *** [/home/acme/git/build/perf/builtin-diff.o] Error 1
> make: Leaving directory `/home/git/linux/tools/perf'
> [acme@sandy linux]$ cat /etc/redhat-release 
> Red Hat Enterprise Linux Server release 6.3 (Santiago)
> [acme@sandy linux]$

Does:

SLANG_INC ?= -I=/usr/include/slang

work any better? Its hard to tell from the above error which bit of the
syntax is failing. Which gcc version is it?

Cheers,

Richard




