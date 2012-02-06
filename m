Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2BFPrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:47:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33108 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab2BFPrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:47:20 -0500
Date: Mon, 6 Feb 2012 16:47:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
Message-ID: <20120206154700.GA13478@elte.hu>
References: <CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
 <20120204135110.GA6437@elte.hu>
 <CABPqkBTvoNBBdzvS-njoFk+SrTf-BKQSvP54C05un+m7RA+nBg@mail.gmail.com>
 <CABPqkBQdRwKKAvgK339Po0-WBW-MJkgcmpWqS=OOgepn3_XiRw@mail.gmail.com>
 <1328523130.2220.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CABPqkBQLn+5fYtOjhpKjXSzvKesuo+YRXxaawyTGUTQuZ6AjYw@mail.gmail.com>
 <1328526691.2220.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CABPqkBQnDToQczbgW4dCXiu3x2ZTXjAuKS_q_hJ=28Pu_2HexQ@mail.gmail.com>
 <20120206143844.GA23807@elte.hu>
 <CABPqkBR2nydKxU91NUaoKSUX2w+hN4ZFCi1khHPvMLB+Rid33A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBR2nydKxU91NUaoKSUX2w+hN4ZFCi1khHPvMLB+Rid33A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Mon, Feb 6, 2012 at 3:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> >> Ok, I found the problem!
> >>
> >> it comes from perf_adjust_freq_unthr_context() vs perf_adjust_period().
> >> The latter can under certain condition stop and restart the event. So we
> >> had:
> >>
> >>       stop()
> >>       if (delta > 0) {
> >>            perf_adjust_period() {
> >>                if (period > 8*...) {
> >>                    stop()
> >>                    ...
> >>                    start()
> >>                }
> >>            }
> >>        }
> >>        start()
> >>
> >> Could have a double stop() and double start(), thus triggering the warning in
> >> x86_pmu_start().
> >>
> >> Will post a patch shortly to fix this.
> >
> > Please send a patch against tip:master (or perf/urgent), on top
> > of:
> >
> >  84f2b9b2edc0: perf: Remove deprecated WARN_ON_ONCE()
> >
> > Note that I updated that patch to removed one more WARN_ON()
> > than you originally sent - please add it back as appropriate, in
> > the delta fix patch.
> >
> I have already added the warning back. Will send against tip:master

Great - thanks!

	Ingo
