Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1ERVVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:21:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1ERVVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:21:07 -0400
Date: Wed, 18 May 2011 23:20:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
Message-ID: <20110518212054.GC28476@elte.hu>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <20110419102600.GU31407@erda.amd.com>
 <1305753398.2466.7180.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305753398.2466.7180.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> >                         if (c->weight != w)
> >                                 continue;
> >  
> > -                       for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
> > -                               if (!test_bit(j, used_mask))
> > +                       /* for each bit in idxmsk starting from idx */
> > +                       while (idx < X86_PMC_IDX_MAX) {
> > +                               idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX,
> > +                                                   idx);
> 
> I'd be mighty tempted to ignore that 80 column rule here ;-)

Please put the body of the loop into a helper function, the function is large 
and there are countless col80 uglinesses in it!

Thanks,

	Ingo
