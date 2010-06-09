Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab0FIMer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:34:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42962 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab0FIMep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:34:45 -0400
Date: Wed, 9 Jun 2010 13:33:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Brian Swetland <swetland@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100609123356.GA7340@sirena.org.uk>
References: <1275834706.7227.545.camel@mulgrave.site> <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain> <1275844114.7227.552.camel@mulgrave.site> <20100606190525.GA20517@infradead.org> <AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com> <20100606192405.GA7559@infradead.org> <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
X-Cookie: Nothing happens.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 12:58:10PM -0700, Brian Swetland wrote:
> On Sun, Jun 6, 2010 at 12:24 PM, Christoph Hellwig <hch@infradead.org> wrote:

> > On the other hand I've heard
> > that various hardware vendors or parties closed to them are rather
> > annoyed by their drivers beeing stuck in the android tree - but that
> > can be easily solved by getting removing the suspend blockers (at least
> > temporarily), cleaning up a few bits here and there and getting them in.

> This continues to baffle me.  If we (Google) are such a headache, why
> not just route around us.  The drivers we've written are GPLv2, the
> source is out there for anyone who wants it, etc.  The drivers other
> people have written we have no control over at all. From my point of
> view it'd be an annoyance if somebody took the code we wrote, modified
> it heavily, and pushed it upstream, but fundamentally I can't stop
> that from happening other than by pushing it upstream myself, first.

AFAICT this is purely down to the fact that the vendors producing
Android devices are using the kernel which is shipped with whatever
release they are using so people doing drivers end up getting locked in
to an older kernel with old APIs (independant of Android specifics) and
don't have the resource to redo things for upstream.  Suspend blockers
are one more API update in there, but general kernel development creates
far more.

I was looking at this just today and one thing that it occurs to me
might help is if when you guys rebase your work against upstream you
were to tag the results - at the minute the only "release" Android
kernels are those included in full stack releases so providing more
hints that other kernel versions could be substituted in may help.
