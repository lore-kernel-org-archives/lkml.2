Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2ECIB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:01:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:35440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2ECIB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:01:57 -0400
Message-ID: <1336032100.13683.193.camel@twins>
Subject: Re: [GIT PULL 0/5] perf/annotate fixes and improvements
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Date: Thu, 03 May 2012 10:01:40 +0200
In-Reply-To: <20120502211805.GH5745@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
	 <1335988003.13683.182.camel@twins> <20120502211805.GH5745@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 18:18 -0300, Arnaldo Carvalho de Melo wrote:
> I.e. the fixed vertical line now has a diff color and the jump arrows are
> _after_ the jump labels that then stands out as a separated columns.

Note that if you have the source-code annotated thing enabled (which
seems to be the default) the arrows go straight through the source.

Also, in this case the asm is dark blue, which is nearly invisible on my
black background.

> In addition, as you suggested, the extra arrows on the ends of a jump->label
> arrow gets swallowed by the jump->label arrow.

Does look nice, thanks!

An alternative to all this arrow drawing could be to high-light the
jump-target, maybe not a full bar like the cursor line but something
like that.

Also, is there a key to jump to the jump target? I was instinctively
pressing '%' to do that, but that could be my vim brain-damage :-)

> Now a question: when I add multiple event column overheads, do you think we
> should have N fixed vertical lines separating them?

I'd start with that and go from there.

> I probably need to add an space before the instructions and the arrow
> start/end, or not? 

Since its a dynamic arrow (in a nearly invisible colour) it doesn't
really matter. But what happens when a function is large enough that
function offset doesn't fit in 2 hex digits anymore? Aah I see, that
width is dynamic, OK.
