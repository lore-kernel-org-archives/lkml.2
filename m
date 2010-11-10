Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0KJS1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:27:52 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:52919 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754721Ab0KJS1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:27:51 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19jL0FFCKJjo1eqCFrERNa1SaKlcsqDnAzL5j8Jf4
	wiy4V85p+SO5rW
Subject: Re: 2.6.36 io bring the system to its knees
From: Mike Galbraith <efault@gmx.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        dave b <db.pub.mail@gmail.com>, Sanjoy Mahajan <sanjoy@olin.edu>,
        Jesper Juhl <jj@chaosbits.net>, Chris Mason <chris.mason@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
In-Reply-To: <AANLkTinYZ2wPeeunFv4Ljm+D9SDLbgzTVmw_P9KQdK16@mail.gmail.com>
References: <20101105014334.GF13830@dastard>
	 <E1PELiI-0001Pj-8g@approx.mit.edu>
	 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
	 <4CD696B4.6070002@kernel.dk>
	 <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
	 <20101110013255.GR2715@dastard>
	 <AANLkTinpLuzd5c+WqXoa_0Z=nv=mDgd-k4QZbBZHsQnD@mail.gmail.com>
	 <AANLkTinYZ2wPeeunFv4Ljm+D9SDLbgzTVmw_P9KQdK16@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 11:27:31 -0700
Message-ID: <1289413651.4382.15.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 18:46 +0200, Alexey Dobriyan wrote:
> On Wed, Nov 10, 2010 at 5:59 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Tue, Nov 9, 2010 at 5:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>
> >> Don't forget to mention data=writeback is not the default because if
> >> your system crashes or you lose power running in this mode it will
> >> *CORRUPT YOUR FILESYSTEM* and you *WILL LOSE DATA*.
> >
> > You will lose data even with data=ordered. All the data that didn't
> > get logged before the crash is lost anyway.
> 
> Linus, are you using with data=writeback?
> 
> Those of us, who did (without UPS), will never do it again.

I've been using it for a looong time on my desktop box.  Yeah, you can
be bitten easier than ordered, and I have been, but it's never been
anything major.  The risk for me is worth it, as data=ordered sucked
really bad.

If I didn't need to maintain compatibility with 30+ old kernels for
regression testing, I'd upgrade desktop to ext4, and likely be happy.

> Propability of non-trivial FS corruption becomes so much bigger.
> I believe from my experience, average number of crashes before
> one loses FS becomes single digit number.

That's not my experience.  I've yet to have to rebuild my ext3 fs since
upgrading box to shiny new opensuse 11.1 (however long ago and how many
many explosions ago that was;)

> With data=ordered, it's quite hard.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


