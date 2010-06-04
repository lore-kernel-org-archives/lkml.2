Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab0FDKIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:08:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:60916 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0FDKIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:08:49 -0400
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
In-Reply-To: <20100604100306.GB3324@elte.hu>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu>
	 <20100603232302.GA16184@elte.hu> <1275644619.27810.39462.camel@twins>
	 <1275645245.27810.39493.camel@twins>  <20100604100306.GB3324@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 12:08:23 +0200
Message-ID: <1275646103.27810.39526.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 12:03 +0200, Ingo Molnar wrote:

> > The only 'interesting' issue I can see here is that if you create 1000 
> > CLOCK_MONOTONIC namepaces, we'd need to have a tree of trees in order to 
> > efficiently find the leftmost timer.
> 
> Realistically Android userspace would create just a single such namespace for 
> all the untrusted/unknown/uncontrolled apps, right?

Possibly, yeah. 

But it might not stop someone else from create an insane amount of them.
So we do need to deal with that, and a linear loop over all timer bases,
which then will be a user controlled quantity, just doesn't sound
right :-)
