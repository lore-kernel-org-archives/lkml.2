Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2INV4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:56:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:43761 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab2INV4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:56:32 -0400
Message-ID: <1347659777.7172.97.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Fri, 14 Sep 2012 23:56:17 +0200
In-Reply-To: <CA+55aFz6SxLEr0MNubz7rcwcqki7EM33Vp-q3KFEvuLG6a61ZQ@mail.gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic> <1347658843.7172.90.camel@twins>
	 <CA+55aFz6SxLEr0MNubz7rcwcqki7EM33Vp-q3KFEvuLG6a61ZQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 14:44 -0700, Linus Torvalds wrote:
> On Fri, Sep 14, 2012 at 2:40 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > The problem the patch is trying to address is not having to scan an
> > entire package for idle cores on every wakeup now that packages are
> > getting stupid big.
> 
> No, it does something *else* too. That whole "left-right" logic to
> (according to the commit message) "prevent bouncing" is entirely new,
> afaik.
> 
> So it is *not* just about avoiding to have to scan the whole package.
> It changes actual semantics too. No?

Both things change semantics, not looking at the entire package is new
too. But yeah I guess you could look at the exact cross-stitching as an
enhancement to the 'idle_buggy' thing.


