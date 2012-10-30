Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab2J3Jnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:43:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55370 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599Ab2J3Jnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:43:43 -0400
Date: Tue, 30 Oct 2012 10:43:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf tools: Speed up the perf build time by simplifying
 the perf --version string generation
Message-ID: <20121030094338.GA21644@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <20121026170503.GC20695@ghostprotocols.net>
 <20121027131935.GA30001@gmail.com>
 <20121030081807.GA8245@gmail.com>
 <20121030084600.GB8245@gmail.com>
 <20121030093513.GE25959@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030093513.GE25959@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Tue, Oct 30, 2012 at 09:46:00AM +0100, Ingo Molnar escreveu:
> > +++ b/tools/perf/util/PERF-VERSION-GEN
> > @@ -12,7 +12,7 @@ LF='
> >  # First check if there is a .git to get the version from git describe
> >  # otherwise try to get the version from the kernel makefile
> >  if test -d ../../.git -o -f ../../.git &&
> > -	VN=$(git describe --match 'v[0-9].[0-9]*' --abbrev=4 HEAD 2>/dev/null) &&
> > +	VN=$(echo $(git tag --list "v[0-9].[0-9]*" | tail -1)"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD) 2>/dev/null) &&
> 
> [acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
> make: Entering directory `/home/git/linux/tools/perf'
> error: unknown option `list'
> usage: git tag [-a|-s|-u <key-id>] [-f] [-m <msg>|-F <file>] <tagname>
> [<head>]
> 
> <SNIP>
> 
> [acme@sandy linux]$ git --version
> git version 1.7.1

Does -l work?

Alternatively, please replace:

  git tag --list "v[0-9].[0-9]*" | tail -1

with:

  git tag | tail -1 | grep -E "v[0-9].[0-9]*"

which is just as fast.

Thanks,

	Ingo
