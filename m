Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0JUKEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:04:54 -0400
Received: from canuck.infradead.org ([134.117.69.58]:55913 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0JUKEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:04:53 -0400
Subject: Re: [PATCH v3] Add generic exponentially weighted moving average
 (EWMA) function
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com, Lars_Ericsson@telia.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
In-Reply-To: <201010211440.24936.br1@einfach.org>
References: <20101020082336.28281.77747.stgit@localhost6.localdomain6>
	 <1287587023.3488.27.camel@twins>  <201010211440.24936.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Oct 2010 12:04:35 +0200
Message-ID: <1287655475.3488.99.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 14:40 +0900, Bruno Randolf wrote:
> On Thu October 21 2010 00:03:43 Peter Zijlstra wrote:
> > On Wed, 2010-10-20 at 17:23 +0900, Bruno Randolf wrote:
> > > +/**
> > > + * ewma_add() - Exponentially weighted moving average (EWMA)
> > > + * @avg: Average structure
> > > + * @val: Current value
> > > + *
> > > + * Add a sample to the average.
> > > + */
> > > +struct ewma*
> > > +ewma_add(struct ewma *avg, const unsigned int val)
> > > +{
> > > +       avg->internal = avg->internal  ?
> > > +               (((avg->internal * (avg->weight - 1)) +
> > > +                       (val * avg->factor)) / avg->weight) :
> > > +               (val * avg->factor);
> > > +       return avg;
> > > +}
> > > +EXPORT_SYMBOL(ewma_add);
> > 
> > How can it be a weighted avg if each sample has the same weight?
> 
> by applying the weight again and again, we get an exponential weighting.
> 
> http://en.wikipedia.org/wiki/Exponentially_weighted_moving_average

Ah, thanks. It might be worth adding some of that explanation to the
actual comment.

I think the naming is somewhat unfortunate since a weighted average
makes me think of:

       \Sum w_i * v_i
 wa = ---------------
         \Sum w_i

Instead of the described algorithm.
