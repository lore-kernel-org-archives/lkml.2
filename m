Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab0D1NhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:37:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53135 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab0D1NhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:37:21 -0400
Date: Wed, 28 Apr 2010 15:37:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Message-ID: <20100428133702.GA3193@elte.hu>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com>
 <20100425173912.GA5375@nowhere>
 <20100426072541.GA25961@elte.hu>
 <201004261329.28427.arnd@arndb.de>
 <20100427092530.GD11348@elte.hu>
 <20100428132112.GC12017@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428132112.GC12017@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> [...]
> 
> That said, once we reach that point with 4 users of bkl remaining, may be 
> that will be time to buy such hardware for a symbolic $1 in obscure places 
> and do the tests. Or just git-rm if we are too lazy.

Precisely. Note that the actual value of BKL-covered code shrinks every time 
we push the BKL out of commonly used code.

So even if there's still usage sites around, there will be a point where it 
makes sense to just desupport it or do a final, crude conversion. If there are 
no active users who are willing to help us debug potential bugs then there's 
frankly no value in us being just as careful with those drivers as we are with 
other, more commonly used code.

For the rest, lockdep & softlockup detector will be plenty enough to debug any 
bugs that may slip through - just like you did it with ReiserFS.

	Ingo
