Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0FDJyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:54:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab0FDJyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:54:18 -0400
Subject: Re: suspend blockers & Android integration
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Arve Hj?nnev?g <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1275644619.27810.39462.camel@twins>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu>
	 <20100603232302.GA16184@elte.hu>  <1275644619.27810.39462.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 11:54:05 +0200
Message-ID: <1275645245.27810.39493.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 11:43 +0200, Peter Zijlstra wrote:
> I still believe containment is a cgroup problem. The freeze/snapshot/resume
> container folks seem to face many of the same problems. Including the
> pending timer one I suspect. Lets solve it there. 

While talking to Thomas about this, we'd probably need a CLOCK_MONOTONIC
namespace to pull this off, so that resumed apps don't see the jump in
absolute time.

This would also help with locating the relevant timers, since they'd be
on the related timer base.

The only 'interesting' issue I can see here is that if you create 1000
CLOCK_MONOTONIC namepaces, we'd need to have a tree of trees in order to
efficiently find the leftmost timer.
