Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab2IEUyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:54:47 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:54234 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab2IEUyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:54:45 -0400
Date: Wed, 5 Sep 2012 13:54:39 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Liang Li <liang.li@windriver.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, richard.purdie@linuxfoundation.org
Subject: Re: [RFC PATCH] perf: add SLANG_INC for slang.h
Message-ID: <20120905205439.GD8203@ghostprotocols.net>
References: <1345777839-15843-1-git-send-email-liang.li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345777839-15843-1-git-send-email-liang.li@windriver.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 24, 2012 at 11:10:39AM +0800, Liang Li escreveu:
> CFLAGS was previously hard coded to contain "-I/usr/include/slang" to
> work with hosts that have "/usr/include/slang/slang.h" as well as hosts
> that have "/usr/include/slang.h". This path can cause compile warnings
> like:
> 
> cc1: warning: '/usr/include/slang' doesn't exists.
> 
> or
> 
> cc1: warning: include location "/usr/include/slang" is unsafe for
> cross-compilation [-Wpoison-system-directories]
> 
> Then in some cases warnings become errors if WERROR is enabled hence
> build errors.
> 
> To fix this issue, we can use -idirafter to downgrade the priority of the
> default hard coded path. We can also make the slang include directory
> a variable, to allow the user to specify SLANG_INC and set their own
> include location. And add a '=' prefix to indicate better
> compatibility with sysroot/cross compile cases.

    CC /home/acme/git/build/perf/builtin-diff.o
In file included from util/../ui/keysyms.h:4,
                 from util/hist.h:142,
                 from builtin-diff.c:11:
util/../ui/libslang.h:12:19: error: slang.h: No such file or directory
util/../ui/libslang.h:14:5: error: "SLANG_VERSION" is not defined
In file included from util/../ui/keysyms.h:4,
                 from util/hist.h:142,
                 from util/evsel.h:10,
                 from util/evlist.h:8,
                 from builtin-annotate.c:20:
util/../ui/libslang.h:12:19: error: slang.h: No such file or directory
util/../ui/libslang.h:14:5: error: "SLANG_VERSION" is not defined
builtin-annotate.c: In function ‘hists__find_annotations’:
builtin-annotate.c:122: error: ‘SL_KEY_RIGHT’ undeclared (first use in
this function)
builtin-annotate.c:122: error: (Each undeclared identifier is reported
only once
builtin-annotate.c:122: error: for each function it appears in.)
builtin-annotate.c:134: error: ‘SL_KEY_LEFT’ undeclared (first use in
this function)
make: *** [/home/acme/git/build/perf/builtin-annotate.o] Error 1
make: *** Waiting for unfinished jobs....
make: *** [/home/acme/git/build/perf/builtin-diff.o] Error 1
make: Leaving directory `/home/git/linux/tools/perf'
[acme@sandy linux]$ cat /etc/redhat-release 
Red Hat Enterprise Linux Server release 6.3 (Santiago)
[acme@sandy linux]$
