Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992894Ab2KOHnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:43:15 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:55571 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992679Ab2KOHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:43:14 -0500
Date: Thu, 15 Nov 2012 09:43:07 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Namhyung Kim <namhyung@kernel.org>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/5] perf ui/gtk: Separate out GTK codes to a shared
 object
In-Reply-To: <1352911664-24620-1-git-send-email-namhyung@kernel.org>
Message-ID: <alpine.LFD.2.02.1211150942260.2386@tux.localdomain>
References: <1352911664-24620-1-git-send-email-namhyung@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Namhyung Kim wrote:
> This is an RFC patchset to separate GTK GUI codes to a shared object,
> called libperf-gtk.so and use it with libdl.  It's in an early-stage
> so probably has some rough edges, but I'd like to get some comments.
> 
> For now, the libperf-gtk.so (I'm open to a better name suggestion)
> contains whole libperf.a and libtraceevent.a for simplicity.  And
> because of that, every single object in perf tools needs to be built
> as a PIC like libtraceevent does.
> 
> As a result, library dependency of the perf itself reduced like this:

[snip]

> To run GTK report browser, you can do it with usual --gtk option but
> you might need to setup LD_LIBRARY_PATH.
> 
>   $ LD_LIBRARY_PATH=$PWD ./perf report --gtk
> 
> Missing LD_LIBRARY_PATH will lead to a fallback TUI or stdio (for 
> NO_NEWT=1 build) report browser.

What's the benefit of doing this? Requiring users to specify 
LD_LIBRARY_PATH seems like a major PITA.

			Pekka
