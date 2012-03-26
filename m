Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab2CZRiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:38:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39394 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122Ab2CZRiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:38:21 -0400
Date: Mon, 26 Mar 2012 14:38:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC PATCHSET] perf ui: Small preparation on further UI work
Message-ID: <20120326173817.GN25820@infradead.org>
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 26, 2012 at 05:51:31PM +0900, Namhyung Kim escreveu:
> This is my initial work of UI generalization. As we now get GTK2 support on
> perf report, improve setup_browser() to handle it properly so that we can
> add various UI specific initialization codes to the function. At least, we
> need basic error/warning handlers ASAP to see what's going on when an error
> occurred, IMHO.
> 
> I put new file setup.c under ui directory (not under util/ui) and it may or
> may not be compiled depending on the system configuration. I think it'd be
> better moving generic UI codes to the directory and TUI specific codes to
> ui/tui, and so on, so that the util directory doesn't contain any UI codes.
> But before proceeding, I'd like to listen to your opinions :).

My plans were for util/ui/ to be this generalization you want to, hence
I didn't use the 't', i.e. I didn't call it util/tui/, because tui would
be just one of the possible backends.

But that still needs more work that I haven't be able to pursue. Pekka
thinks that doing it that way is not OK as it would limit what one could
do with a more featureful UI like GTK+.

I would like to still pursue a simple GUI using a function table for
the simple operations we use in the hists browser in
tools/perf/util/ui/ but if others want to pursue it the way the GTK+
browser is being worked on, more power to them.

So I would just leave things in tools/perf/util/ui/ and do what you did
in moving the TUI specific bits to a separate function, even ui__init()
would be ok for now, and then at setup_browser() check what kind of
interface is being used and call ui__init() if it is the TUI and the
gtk init one if GTK+ was chosen.

But wouldn't introduce tools/perf/ui/setup.c for that, no need for new
directory trees, I think :-)

- Arnaldo
 
> Any comments are welcome.
> Thanks.
> 
> Namhyung Kim (5):
>   perf ui: Make setup_browser() generic
>   perf ui: Drop arg[cv] arguments from perf_gtk_setup_browser()
>   perf ui: Add gtk2 support into setup_browser()
>   perf gtk: Rename functions for consistency
>   perf ui: Change fallback policy of setup_browser()
> 
>  tools/perf/Makefile           |    7 ++++-
>  tools/perf/builtin-report.c   |    5 +---
>  tools/perf/ui/setup.c         |   44 +++++++++++++++++++++++++++++
>  tools/perf/util/cache.h       |   24 +++++++++++-----
>  tools/perf/util/gtk/browser.c |   27 +++++++++---------
>  tools/perf/util/gtk/gtk.h     |    4 +++
>  tools/perf/util/ui/setup.c    |   61 +++++++++++++++-------------------------
>  7 files changed, 108 insertions(+), 64 deletions(-)
>  create mode 100644 tools/perf/ui/setup.c
> 
> -- 
> 1.7.7.6
