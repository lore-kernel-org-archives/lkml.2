Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab2C1O2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:28:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43727 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2C1O2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:28:13 -0400
Date: Wed, 28 Mar 2012 11:28:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC PATCHSET] perf ui: Small preparation on further UI work
Message-ID: <20120328142808.GA8482@infradead.org>
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
 <20120326173817.GN25820@infradead.org>
 <87pqbx320u.fsf@youngshil.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqbx320u.fsf@youngshil.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 28, 2012 at 11:14:25AM +0900, Namhyung Kim escreveu:
> Em Tue, Mar 27, 2012 at 01:44:42PM +0300, Pekka Enberg escreveu: 
> > Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> > So I would just leave things in tools/perf/util/ui/ and do what you did
> > in moving the TUI specific bits to a separate function, even ui__init()
> > would be ok for now, and then at setup_browser() check what kind of
> > interface is being used and call ui__init() if it is the TUI and the
> > gtk init one if GTK+ was chosen.
> 
> I think it'd be better moving the TUI specific codes to a separate file
> (under a separate directory, like tools/perf/util/ui/tui - but it looks
> like so deep nesting) rather than a function since the generic

What do you have against directory trees? :P We need to chop off the
/util/ part, but apart from that...

> code (setup_browser) should be compiled without the TUI support.
> Otherwise we'll see some #ifdef's in the source file(s).
> 
> Or, we can put those codes under the same directory (tools/perf/util/ui)
> and have different suffixes - say, if generic code were XXX.c, TUI one
> would be XXX-tui.c and GTK+ one would be XXX-gtk.c.

... what is the difference of using:

tools/perf/util/ui/tui/init.c

instead of:

tools/perf/util/ui/tui-init.c

?

Since we'll be introducing new files, it seems the first step would be
to just do a simple, no changes in the files, move of
tools/perf/util/ui/ to tools/perf/ui/ and then introduce
tools/perf/ui/tui/{init,etc}.c

Gtk would as well be moved to tools/perf/ui/gtk/.

At some point we would then introduce some sort of plugin mechanism
where files found in /usr/lib/perf/ui/ or some other suitable directory
would be loaded in a modprobe like way, i.e. if the user asks for --gtk,
it would try to find /usr/lib/perf/ui/gtk.so and try to load it, etc.

That way we start to reduce the miriad libraries that we have linked in
the main perf binary, making it easier for packaging, etc.

- Arnaldo
