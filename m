Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1ERVhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:37:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:52801 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab1ERVhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:37:10 -0400
Subject: Re: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110518212054.GC28476@elte.hu>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
	 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
	 <20110419102600.GU31407@erda.amd.com> <1305753398.2466.7180.camel@twins>
	 <20110518212054.GC28476@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 May 2011 23:36:53 +0200
Message-ID: <1305754613.2466.7190.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 23:20 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > >                         if (c->weight != w)
> > >                                 continue;
> > >  
> > > -                       for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
> > > -                               if (!test_bit(j, used_mask))
> > > +                       /* for each bit in idxmsk starting from idx */
> > > +                       while (idx < X86_PMC_IDX_MAX) {
> > > +                               idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX,
> > > +                                                   idx);
> > 
> > I'd be mighty tempted to ignore that 80 column rule here ;-)
> 
> Please put the body of the loop into a helper function, the function is large 
> and there are countless col80 uglinesses in it!

I just tried that, its real ugly due to the amount of state you need to
pass around.
