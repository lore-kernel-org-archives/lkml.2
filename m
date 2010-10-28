Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab0J1Naz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:30:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab0J1Nax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:30:53 -0400
Date: Thu, 28 Oct 2010 15:30:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101028133036.GA30565@elte.hu>
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com>
 <AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
 <AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
 <AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
 <AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
 <20101028090002.GA12446@elte.hu>
 <AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> * Pekka Enberg <penberg@kernel.org> wrote:
> >> On Thu, Oct 28, 2010 at 9:09 AM, Aidar Kultayev <the.aidar@gmail.com> wrote:
> >> > Find attached screenshot ( latencytop_n_powertop.png ) which depicts
> >> > artifacts where the window manager froze at the time I was trying to
> >> > see a tab in Konsole where the powertop was running.
> >>
> >> You seem to have forgotten to include the attachment.
> 
> On Thu, Oct 28, 2010 at 12:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > I got it - it appears it was too large for lkml's ~500K mail size limit.
> >
> > Aidar, mind sending a smaller image?
> 
> Looks mostly VFS to me. Aidar, does killing Picasa make things smoother for you? 
> If so, maybe the VFS scalability patches will help.

Hm, but the VFS scalability patches mostly decrease CPU usage, and does that mostly 
on many-core systems.

While the bugreport here is rather plain:

> How do I notice slowdowns ? The JuK lags so badly that it can't play any music, 
> the mouse pointer freezes, kwin effects freeze for few seconds.
>
> How can I make it much worse ? I can try & run disk clean up under XP, that is 
> running in VBox, with folder compression. On top of it if I start copying big 
> files in linux ( 700MB avis, etc ), GUI effects freeze, mouse pointer freezes for 
> few seconds.
>
> And this is on 2.6.36 that is supposed to cure these "features". From this 
> perspective, 2.6.36 is no better than any previous stable kernel I've tried. 
> Probably as bad with regards to IO issues.

"Many seconds freezes" and slowdowns wont be fixed via the VFS scalability patches 
i'm afraid.

This has the appearance of some really bad IO or VM latency problem. Unfixed and 
present in stable kernel versions going from years ago all the way to v2.6.36.

Thanks,

	Ingo
