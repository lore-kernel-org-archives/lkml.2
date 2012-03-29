Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2C2BEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:04:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48015 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2C2BEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:04:00 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-ec-4f73b4fa0df3
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC PATCHSET] perf ui: Small preparation on further UI work
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
	<20120326173817.GN25820@infradead.org>
	<87pqbx320u.fsf@youngshil.aot.lge.com>
	<20120328142808.GA8482@infradead.org>
Date: Thu, 29 Mar 2012 10:03:53 +0900
In-Reply-To: <20120328142808.GA8482@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Wed, 28 Mar 2012 11:28:08 -0300")
Message-ID: <87obrgcj5y.fsf@youngshil.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 28 Mar 2012 11:28:08 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Mar 28, 2012 at 11:14:25AM +0900, Namhyung Kim escreveu:
>> Em Tue, Mar 27, 2012 at 01:44:42PM +0300, Pekka Enberg escreveu: 
>> > Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
>
>> > So I would just leave things in tools/perf/util/ui/ and do what you did
>> > in moving the TUI specific bits to a separate function, even ui__init()
>> > would be ok for now, and then at setup_browser() check what kind of
>> > interface is being used and call ui__init() if it is the TUI and the
>> > gtk init one if GTK+ was chosen.
>> 
>> I think it'd be better moving the TUI specific codes to a separate file
>> (under a separate directory, like tools/perf/util/ui/tui - but it looks
>> like so deep nesting) rather than a function since the generic
>
> What do you have against directory trees? :P We need to chop off the
> /util/ part, but apart from that...
>
>> code (setup_browser) should be compiled without the TUI support.
>> Otherwise we'll see some #ifdef's in the source file(s).
>> 
>> Or, we can put those codes under the same directory (tools/perf/util/ui)
>> and have different suffixes - say, if generic code were XXX.c, TUI one
>> would be XXX-tui.c and GTK+ one would be XXX-gtk.c.
>
> ... what is the difference of using:
>
> tools/perf/util/ui/tui/init.c
>
> instead of:
>
> tools/perf/util/ui/tui-init.c
>
> ?
>

Nothing. I just want to remain the directory nesting level if you care. :)


> Since we'll be introducing new files, it seems the first step would be
> to just do a simple, no changes in the files, move of
> tools/perf/util/ui/ to tools/perf/ui/ and then introduce
> tools/perf/ui/tui/{init,etc}.c
>
> Gtk would as well be moved to tools/perf/ui/gtk/.
>

Yeah, This is what I wanted to have from the begining. I'll revise my
patches after moving the files to tools/perf/ui.

> At some point we would then introduce some sort of plugin mechanism
> where files found in /usr/lib/perf/ui/ or some other suitable directory
> would be loaded in a modprobe like way, i.e. if the user asks for --gtk,
> it would try to find /usr/lib/perf/ui/gtk.so and try to load it, etc.
>
> That way we start to reduce the miriad libraries that we have linked in
> the main perf binary, making it easier for packaging, etc.
>
> - Arnaldo

That would be great!

Thanks,
Namhyung
