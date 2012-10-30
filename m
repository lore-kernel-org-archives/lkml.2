Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2J3ISg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:18:36 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37419 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2J3ISN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:18:13 -0400
Date: Tue, 30 Oct 2012 09:18:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20121030081807.GA8245@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <20121026170503.GC20695@ghostprotocols.net>
 <20121027131935.GA30001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121027131935.GA30001@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > Em Fri, Oct 26, 2012 at 04:54:51PM +0200, Ingo Molnar escreveu:
> > > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > > > . Makefile improvements from Namhyung Kim.
> > > 
> > > These are really useful: there used to be a couple of 
> > > seconds of wait time at the beginning of every perf build - 
> > > these are now nicely explained with the various CHK entries.
> > 
> > The optimal way, I guess, would be to have some cache file 
> > with the results of such feature tests, that would be created 
> > and then used till the build fails using its findings, which 
> > would trigger a new feature check round, followed by an 
> > automatic rebuild.
> > 
> > That would be tricky because we would have to have an 
> > automated way of discovering if the build failed due to 
> > missing packages or if it failed due to some ordinary coding 
> > mistake.
> 
> The feature tests aren't a big problem right now - but making 
> it *visible* is really useful. It also tells us which feature 
> test fails, etc.

Btw., there's another thing that would be nice in addition to 
simplifying the PERF-VERSION-GEN script: to be able to run the 
CHK tests in parallel, like the object file runes.

Right now the CHK tests are serialized and they take several 
seconds to build and run. A parallel make rule would reduce
that to about a second I think.

Thanks,

	Ingo
