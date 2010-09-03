Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0ICIAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:00:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:36495 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab0ICIAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:00:04 -0400
Subject: Re: [RFC][PATCH 2/3] sched: On-demand cfs_rq list
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
In-Reply-To: <AANLkTineCQ=7wt_ErN6sw5TP1z2Yp1Gvoo0Y0jyp7Gjq@mail.gmail.com>
References: <20100828223025.054328145@chello.nl>
	 <20100828223547.016319253@chello.nl>
	 <AANLkTineCQ=7wt_ErN6sw5TP1z2Yp1Gvoo0Y0jyp7Gjq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 09:59:29 +0200
Message-ID: <1283500769.1783.134.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 04:33 +0100, Paul Turner wrote:
> > @@ -668,6 +693,11 @@ static void update_cfs_load(struct cfs_r
> >                cfs_rq->load_period /= 2;
> >                cfs_rq->load_avg /= 2;
> >        }
> > +
> > +       if (lb && !cfs_rq->nr_running) {
> > +               if (cfs_rq->load_period < (period / 8))
> > +                       list_del_leaf_cfs_rq(cfs_rq);
> > +       }
> >  }
> >
> 
> In the case of zero load, load_avg above will decay however
> load_period will remain in the range  [period/2, period], any entity
> that has passed period/8 time will remain on the leaf rq list.

Right, already changed that to cfs_rq->load_avg < (period / 8) after you
pointed that out on irc..

> The lb condition could also be relaxed in the dequeue_entity case.
> 
Possibly yeah, we'll have to see if that makes much difference.
