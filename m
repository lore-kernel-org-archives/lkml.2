Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2C0Kox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:44:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62242 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2C0Kou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:44:50 -0400
Date: Tue, 27 Mar 2012 13:44:42 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCHSET] perf ui: Small preparation on further UI work
In-Reply-To: <20120326173817.GN25820@infradead.org>
Message-ID: <alpine.LFD.2.02.1203271337290.19635@tux.localdomain>
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com> <20120326173817.GN25820@infradead.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012, Arnaldo Carvalho de Melo wrote:
> My plans were for util/ui/ to be this generalization you want to, hence
> I didn't use the 't', i.e. I didn't call it util/tui/, because tui would
> be just one of the possible backends.
> 
> But that still needs more work that I haven't be able to pursue. Pekka
> thinks that doing it that way is not OK as it would limit what one could
> do with a more featureful UI like GTK+.
> 
> I would like to still pursue a simple GUI using a function table for
> the simple operations we use in the hists browser in
> tools/perf/util/ui/ but if others want to pursue it the way the GTK+
> browser is being worked on, more power to them.
> 
> So I would just leave things in tools/perf/util/ui/ and do what you did
> in moving the TUI specific bits to a separate function, even ui__init()
> would be ok for now, and then at setup_browser() check what kind of
> interface is being used and call ui__init() if it is the TUI and the
> gtk init one if GTK+ was chosen.
> 
> But wouldn't introduce tools/perf/ui/setup.c for that, no need for new
> directory trees, I think :-)

I actually completely agree that we should aggressively consolidate code 
between TUI and GTK back-ends. I also do think going for function table 
for simple operations make sense.

What I think we disagreed about is that I don't want to make a totally new 
abstraction for perf that hides the differences between TUI and GTK 
completely. That is, I think both UI implementations should be allowed to 
have different UI layouts and use all the toolkit specific extensions if 
necessary.

I completely missed the newly added tools/perf/ui directory which doesn't 
make much sense. We definitely ought to consolidate all this code under 
tools/perf/util/ui and gradually move the tui code out of it instead.

[ I would, however, like to make the directory nesting less deep by 
  dropping the "util" part from the directory name. But that's a 
  completely different topic. ]

			Pekka
