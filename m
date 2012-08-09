Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab2HIRO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:14:26 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52795 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2HIROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:14:24 -0400
Date: Thu, 9 Aug 2012 14:14:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf tools: Initial bash completion support
Message-ID: <20120809171419.GC4084@infradead.org>
References: <1344522713-27951-1-git-send-email-fweisbec@gmail.com>
 <1344522713-27951-2-git-send-email-fweisbec@gmail.com>
 <20120809163515.GA4084@infradead.org>
 <5023E7F3.8090701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5023E7F3.8090701@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 09, 2012 at 10:40:19AM -0600, David Ahern escreveu:
> On 8/9/12 10:35 AM, Arnaldo Carvalho de Melo wrote:
> >Em Thu, Aug 09, 2012 at 04:31:51PM +0200, Frederic Weisbecker escreveu:
> >>This implements bash completion for perf subcommands such
> >>as record, report, script, probe, etc...
> >
> >Humm, I get this when doing my usual workflow:
> >
> >[acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
> >make: Entering directory `/home/git/linux/tools/perf'
> >PERF_VERSION = 3.6.rc1.152.g5758f7
> ><SNIP>
> >install -d -m 755 '/home/acme/libexec/perf-core/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
> >install -d -m 755 '/home/acme/libexec/perf-core/scripts/python/bin'
> >install scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '/home/acme/libexec/perf-core/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
> >install scripts/python/*.py -t '/home/acme/libexec/perf-core/scripts/python'
> >install scripts/python/bin/* -t '/home/acme/libexec/perf-core/scripts/python/bin'
> >install -m 755 bash_completion /etc/bash_completion.d/perf
> >install: cannot create regular file `/etc/bash_completion.d/perf': Permission denied
> >make: *** [install] Error 1
> >make: Leaving directory `/home/git/linux/tools/perf'
> >[acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
> >
> >	Shouldn't it install on ~/etc/bash_completion.d/perf ?
> >
> >	Is there a way to have per user bash completion files like that?
> 
> 3rd patch should fix this.

Huh? The problem is not /etc/bash_completion.d/ not existing, it exists,
its just that I'm not using sudo nor installing as root, this new bash
completion file is the only one that is being installed on the root
filesystem, all others are in ~acme/

- Arnaldo
