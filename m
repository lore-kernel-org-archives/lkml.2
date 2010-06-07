Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab0FGIE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 04:04:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab0FGIE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 04:04:27 -0400
Date: Mon, 7 Jun 2010 04:03:57 -0400
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
Message-ID: <20100607080357.GB15851@infradead.org>
References: <1275834706.7227.545.camel@mulgrave.site>
 <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
 <1275844114.7227.552.camel@mulgrave.site>
 <20100606190525.GA20517@infradead.org>
 <AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com>
 <20100606192405.GA7559@infradead.org>
 <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 12:58:10PM -0700, Brian Swetland wrote:
> Somebody will have to broker a deal with the frameworks/apps folks to
> get rid of the binder.  They like it a lot.  Of course if somebody
> built a drop-in replacement for the userspace side that didn't require
> a kernel driver, had the same performance characteristics, solved the
> same problems, etc, they could probably make an argument for it (or
> just provide it as a drop-in replacement for people who want a more
> "pure" linux underneath Android, even if we didn't pick it up).

This wasn't really directed at you, but rather about people talking
about running a mainline kernel on Android in this thread.  As I said
this is a lot more work then sorting out the drivers - with or without
suspend blockers.

> The group ID stuff works incredibly well for gating device access --
> we ensure that devices that need access from various processes end up
> with perms like 0660 root audio (say for a raw audio interface), and
> then we assure that processes which have the "may use audio hardware"
> permission are executed with audio as an additional group.  We ended
> up using the same model to control socket, raw socket, and bt socket
> access because at the time we could not find a reasonable way to grant
> or exclude such permissions on a process by process basis.
> Maintaining about 20-30 lines of diffs to make that work was not a bad
> tradeoff (and we don't expect those patches to go upstream).  If
> there's a way to accomplish this without patching the kernel, we're
> all ears.

I'd have to take a look again on how this is implemented in details.
If it's just overriding the capabilities it's really hard to do in
the current model as the capabilities aren't fine grained enough
currently, even with the existing per-file and per-process capabilities.
If it's mostly overriding regular unix file permissions it's easily
doable with ACLs, or in fact just with group ownership at the filesystem
level, without kernel hacks.

