Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0KJO15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:27:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52648 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0KJO14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:27:56 -0500
Date: Wed, 10 Nov 2010 15:27:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, dave b <db.pub.mail@gmail.com>,
        Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101110142721.GA14496@elte.hu>
References: <20101105014334.GF13830@dastard>
 <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
 <4CD696B4.6070002@kernel.dk>
 <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
 <20101110013255.GR2715@dastard>
 <20101110142037.GA1447@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110142037.GA1447@ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > > > As already mentioned, ext3 is just not a good choice for this sort of
> > > > thing. Did you have atimes enabled?
> > > 
> > > At least for ext3, more important than atimes is the "data=writeback"
> > > setting. Especially since our atime default is sane these days (ie if
> > > you don't specify anything, we end up using 'relatime').
> > > 
> > > If you compile your own kernel, answer "N" to the question
> > > 
> > >   Default to 'data=ordered' in ext3?
> > > 
> > > at config time (CONFIG_EXT3_DEFAULTS_TO_ORDERED), or you can make sure
> > > "data=writeback" is in the fstab (but I don't think everything honors
> > > it for the root filesystem).
> > 
> > Don't forget to mention data=writeback is not the default because if your system 
> > crashes or you lose power running in this mode it will *CORRUPT YOUR FILESYSTEM* 
> > and you *WILL LOSE DATA*. Not to mention
> 
> You will lose your data, but the filesystem should still be consistent, right? 
> Metadata are still journaled.

That is data that was freshly touched around the time the system went down, right?

I.e. data that was probably half-modified by user-space to begin with.

	Ingo
