Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab2J3KBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:01:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35953 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2J3KBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:01:40 -0400
Date: Tue, 30 Oct 2012 11:01:34 +0100
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
Message-ID: <20121030100134.GB21644@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <20121026170503.GC20695@ghostprotocols.net>
 <20121027131935.GA30001@gmail.com>
 <20121030081807.GA8245@gmail.com>
 <20121030084600.GB8245@gmail.com>
 <20121030093513.GE25959@ghostprotocols.net>
 <20121030094338.GA21644@gmail.com>
 <20121030094852.GA21705@gmail.com>
 <20121030095752.GG25959@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030095752.GG25959@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Tue, Oct 30, 2012 at 10:48:52AM +0100, Ingo Molnar escreveu:
> > 
> > * Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > Does -l work?
> > > 
> > > Alternatively, please replace:
> > > 
> > >   git tag --list "v[0-9].[0-9]*" | tail -1
> > > 
> > > with:
> > > 
> > >   git tag | tail -1 | grep -E "v[0-9].[0-9]*"
> > > 
> > > which is just as fast.
> > 
> > make that:
> > 
> >     git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*"
> > 
> > this will work silently even if Git is not installed.
> 
> But we first check if we have a .git, that doesn't guarantees 
> that git is installed, but makes it a lot likely, no? 
> [...]

Not necessarily - say a home directory is NFS shared to multiple 
test boxes, one does not have Git installed.

> Redirecting stderr to null would need to be done in more 
> places, so we would need to use something like what we do for 
> xmlto/asciidoc, $(call get-executable,$(GIT))

It at least solves it in this particular case, and I tested it 
with Git uninstalled, there's no extra message just a proper 
error code the script can use to fall back to the toplevel 
Makefile for version info.

Thanks,

	Ingo
