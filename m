Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0FFTYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 15:24:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60155 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0FFTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 15:24:18 -0400
Date: Sun, 6 Jun 2010 15:24:05 -0400
From: Christoph Hellwig <hch@infradead.org>
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
Message-ID: <20100606192405.GA7559@infradead.org>
References: <1275834706.7227.545.camel@mulgrave.site>
 <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
 <1275844114.7227.552.camel@mulgrave.site>
 <20100606190525.GA20517@infradead.org>
 <AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 12:15:10PM -0700, Brian Swetland wrote:
> I was shocked when Greg pulled the binder driver and some of the other
> "generic" android drivers into staging, because it was always my
> assumption that nobody upstream would want them.  We did get some
> bugfixes for the binder driver (thanks!) but the general reaction was
> pretty much the same as yours here.  I then was relatively unsurprised
> when it was dropped (we find it useful, upstream finds it useless, not
> much else to say).
> 
> The various SoC peripheral drivers are, I suspect, much less
> contentious (modulo suspend blocker usage and any necessary kernel
> style cleanup).

Yes.  That's what makes me wonder about some parts of the discussion
here.  Getting the drivers for one or more of the android plattforms
in is not a problem.  I'd say it could have easily been done with the
manweeks spent arguing in this and related threads.

The much bigger issues is to get android userspace running on a more
or less vanilla kernel, that is withoutthe  binder, without the rather
interesting group ID based security hack^H^H^H^Hmodel, without the
suspend blocker userspace API and so on, and so on.

So for people who really care about running a mainline kernel on their
android device doing that part first on a generic ARM board in qemu
might be much better first step work.   On the other hand I've heard
that various hardware vendors or parties closed to them are rather
annoyed by their drivers beeing stuck in the android tree - but that
can be easily solved by getting removing the suspend blockers (at least
temporarily), cleaning up a few bits here and there and getting them in.

It's not rocket science to get support for ARM SOC number 1654 into the
mainline kernel.

