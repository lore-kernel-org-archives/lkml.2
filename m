Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2ECNFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:05:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38933 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2ECNFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:05:52 -0400
Date: Thu, 3 May 2012 10:05:51 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/5] perf/annotate fixes and improvements
Message-ID: <20120503130551.GA8115@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
 <1335988003.13683.182.camel@twins>
 <20120502211805.GH5745@infradead.org>
 <1336032100.13683.193.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336032100.13683.193.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 03, 2012 at 10:01:40AM +0200, Peter Zijlstra escreveu:
> On Wed, 2012-05-02 at 18:18 -0300, Arnaldo Carvalho de Melo wrote:
> > I.e. the fixed vertical line now has a diff color and the jump arrows are
> > _after_ the jump labels that then stands out as a separated columns.
> 
> Note that if you have the source-code annotated thing enabled (which
> seems to be the default) the arrows go straight through the source.

I thought I had that fixed, damn, will fix.

> Also, in this case the asm is dark blue, which is nearly invisible on my
> black background.

What colour do you suggest? Also what kind of term color scheme do you
use? Finding the right default combo is kinda hard.
 
> > In addition, as you suggested, the extra arrows on the ends of a jump->label
> > arrow gets swallowed by the jump->label arrow.
> 
> Does look nice, thanks!
> 
> An alternative to all this arrow drawing could be to high-light the
> jump-target, maybe not a full bar like the cursor line but something
> like that.
> 
> Also, is there a key to jump to the jump target? I was instinctively
> pressing '%' to do that, but that could be my vim brain-damage :-)

Enter or ->, just like on calls and rets, what is missing is using <- to
go back the stack of navigated jumps, like with calls.
 
> > Now a question: when I add multiple event column overheads, do you think we
> > should have N fixed vertical lines separating them?
> 
> I'd start with that and go from there.

Ok
 
> > I probably need to add an space before the instructions and the arrow
> > start/end, or not? 
> 
> Since its a dynamic arrow (in a nearly invisible colour) it doesn't
> really matter. But what happens when a function is large enough that
> function offset doesn't fit in 2 hex digits anymore? Aah I see, that
> width is dynamic, OK.

Yes, it is, it is calculated at function start and when switching
to/from "O"ffset view.

I need to add a help window with the ever growing list of hot keys.

Also will try to asap make the last features toggled persistent.

- Arnaldo
