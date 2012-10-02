Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2JBVpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:45:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab2JBVps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:45:48 -0400
Date: Tue, 2 Oct 2012 18:45:36 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ben Guthro <ben.guthro@gmail.com>, Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf tool: Fix build for NO_DWARF=1 case
Message-ID: <20121002214536.GA23354@infradead.org>
References: <CAOvdn6WPUDqYPpHZip7dxVVXJXT0-zJOUCpgDGb=o+zqq98F0Q@mail.gmail.com>
 <1349148496-sup-4820@delenn.ozlabs.ibm.com>
 <CAOvdn6VELd9vPGyptmeBePsNsnQNtgXdgj4bYRfuLyz0cXsD9w@mail.gmail.com>
 <20121002131049.GC6379@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121002131049.GC6379@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 02, 2012 at 03:10:49PM +0200, Jiri Olsa escreveu:
> On Tue, Oct 02, 2012 at 07:39:23AM -0400, Ben Guthro wrote:
> > Actually - I hadn't noticed these warnings before.

> > After installing libdw-dev - the perf build completed successfully.
> > Perhaps this should be fatal, rather than a warning?

> attached patch fixies the issue for me. Adding Arnaldo to the loop.

[acme@sandy linux]$ make -j8 -C tools/perf/ LIBUNWIND_DIR=/opt/libunwind O=/home/acme/git/build/perf install
cc1: warnings being treated as errors
arch/x86/util/dwarf-regs.c:72: error: no previous prototype for ‘get_arch_regstr’
make: *** [/home/acme/git/build/perf/arch/x86/util/dwarf-regs.o] Error 1
make: *** Waiting for unfinished jobs....
make: Leaving directory `/home/git/linux/tools/perf'
[acme@sandy linux]$

- Arnaldo
