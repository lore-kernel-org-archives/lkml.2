Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1AZBAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 20:00:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39096 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab1AZBAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 20:00:08 -0500
Date: Wed, 26 Jan 2011 02:00:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/12] perf: Carve out mmap helpers for general use
Message-ID: <20110126010002.GA10568@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Borislav Petkov <bp@amd64.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"fweisbec@gmail.com" <fweisbec@gmail.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
 <1295622575-18607-9-git-send-email-bp@amd64.org>
 <20110121172937.GC15066@ghostprotocols.net>
 <20110124090410.GA8924@aftab>
 <20110124123936.GC5932@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110124123936.GC5932@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:39:36AM -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 24, 2011 at 10:04:10AM +0100, Borislav Petkov escreveu:
> > Ok, I see at least one problem with my patch - you've reworked the
> > mmaping functionality in evlist.c/evsel.c and I should use it too, I
> > guess. For that, I think you'd want me to apply my stuff ontop of your
> > perf/core branch, right?
> 
> Right, I hope to have that branch merged by Ingo soon.
>  
> > Am I missing something else?
> 
> Nope, you're not. Doing that we erode your patchset a bit, reducing its
> size.

.. which means less work for me, heey, nice! :)

> One related experience I'm doing now is to have a perf.so python
> binding, the setup.py file for it with the list of files needed for this
> specific binding is at:
> 
> http://userweb.kernel.org/~acme/setup.py
> 
> A simple tool using the resulting binding is a thread
> fork/comm/exit/sample watcher, available at:
> 
> http://userweb.kernel.org/~acme/twatch
> 
> In this process I'm moving functions around so as to reduce the number
> of tools/perf/util.c files to link into this perf.so python binding,
> untangling things as much as possible.
> 
> The binding proper is:
> 
> http://userweb.kernel.org/~acme/python.c
> 
> I'm digressing, but twatch is an example of a simple "daemon" consuming
> perf events where performance is not much of a problem.
> 
> And provides a prototyping ground when starting to design perf events
> consuming daemons :-)

Yaay, twatch looks almost like a child's play and even my grandma can
profile her system now :).

But yeah, I thought about pythonizing the ras thingy too but the reasons
against it are that we might run on systems which don't have python,
have some obscure/old version of it or we simply don't want to depend on
it or any other additional tool for that matter. Generally, we want to
run with as low overhead as possible when handling hw error info and be
as self-contained as possible.

-- 
Regards/Gruss,
    Boris.
