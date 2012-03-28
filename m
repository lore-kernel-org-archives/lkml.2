Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab2C1COn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:14:43 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50578 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab2C1COm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:14:42 -0400
X-AuditID: 9c930179-b7c1dae000006519-97-4f727401a9e5
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC PATCHSET] perf ui: Small preparation on further UI work
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
	<20120326173817.GN25820@infradead.org>
Date: Wed, 28 Mar 2012 11:14:25 +0900
In-Reply-To: <20120326173817.GN25820@infradead.org> (Arnaldo Carvalho de
	Melo's message of "Mon, 26 Mar 2012 14:38:17 -0300")
Message-ID: <87pqbx320u.fsf@youngshil.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Mon, Mar 26, 2012 at 05:51:31PM +0900, Namhyung Kim escreveu:
>> This is my initial work of UI generalization. As we now get GTK2 support on
>> perf report, improve setup_browser() to handle it properly so that we can
>> add various UI specific initialization codes to the function. At least, we
>> need basic error/warning handlers ASAP to see what's going on when an error
>> occurred, IMHO.
>> 
>> I put new file setup.c under ui directory (not under util/ui) and it may or
>> may not be compiled depending on the system configuration. I think it'd be
>> better moving generic UI codes to the directory and TUI specific codes to
>> ui/tui, and so on, so that the util directory doesn't contain any UI codes.
>> But before proceeding, I'd like to listen to your opinions :).
>
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

Yeah, I was thinking about it too. I think the warning/error reporting
utilties seem to fit for that direction.


> So I would just leave things in tools/perf/util/ui/ and do what you did
> in moving the TUI specific bits to a separate function, even ui__init()
> would be ok for now, and then at setup_browser() check what kind of
> interface is being used and call ui__init() if it is the TUI and the
> gtk init one if GTK+ was chosen.
>

I think it'd be better moving the TUI specific codes to a separate file
(under a separate directory, like tools/perf/util/ui/tui - but it looks
like so deep nesting) rather than a function since the generic
code (setup_browser) should be compiled without the TUI support.
Otherwise we'll see some #ifdef's in the source file(s).

Or, we can put those codes under the same directory (tools/perf/util/ui)
and have different suffixes - say, if generic code were XXX.c, TUI one
would be XXX-tui.c and GTK+ one would be XXX-gtk.c.


> But wouldn't introduce tools/perf/ui/setup.c for that, no need for new
> directory trees, I think :-)
>

OK.

Thanks,
Namhyung
