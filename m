Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1AXMjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:39:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:47532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1AXMjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:39:51 -0500
Date: Mon, 24 Jan 2011 10:39:36 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/12] perf: Carve out mmap helpers for general use
Message-ID: <20110124123936.GC5932@ghostprotocols.net>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
 <1295622575-18607-9-git-send-email-bp@amd64.org>
 <20110121172937.GC15066@ghostprotocols.net>
 <20110124090410.GA8924@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124090410.GA8924@aftab>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 24, 2011 at 10:04:10AM +0100, Borislav Petkov escreveu:
> Ok, I see at least one problem with my patch - you've reworked the
> mmaping functionality in evlist.c/evsel.c and I should use it too, I
> guess. For that, I think you'd want me to apply my stuff ontop of your
> perf/core branch, right?

Right, I hope to have that branch merged by Ingo soon.
 
> Am I missing something else?

Nope, you're not. Doing that we erode your patchset a bit, reducing its
size.

One related experience I'm doing now is to have a perf.so python
binding, the setup.py file for it with the list of files needed for this
specific binding is at:

http://userweb.kernel.org/~acme/setup.py

A simple tool using the resulting binding is a thread
fork/comm/exit/sample watcher, available at:

http://userweb.kernel.org/~acme/twatch

In this process I'm moving functions around so as to reduce the number
of tools/perf/util.c files to link into this perf.so python binding,
untangling things as much as possible.

The binding proper is:

http://userweb.kernel.org/~acme/python.c

I'm digressing, but twatch is an example of a simple "daemon" consuming
perf events where performance is not much of a problem.

And provides a prototyping ground when starting to design perf events
consuming daemons :-)

- Arnaldo
