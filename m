Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0JUFko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 01:40:44 -0400
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:2207 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751403Ab0JUFkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 01:40:43 -0400
From: Bruno Randolf <br1@einfach.org>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3] Add generic exponentially weighted moving average (EWMA) function
Date: Thu, 21 Oct 2010 14:40:24 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com, Lars_Ericsson@telia.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
References: <20101020082336.28281.77747.stgit@localhost6.localdomain6> <1287587023.3488.27.camel@twins>
In-Reply-To: <1287587023.3488.27.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211440.24936.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu October 21 2010 00:03:43 Peter Zijlstra wrote:
> On Wed, 2010-10-20 at 17:23 +0900, Bruno Randolf wrote:
> > +/**
> > + * ewma_add() - Exponentially weighted moving average (EWMA)
> > + * @avg: Average structure
> > + * @val: Current value
> > + *
> > + * Add a sample to the average.
> > + */
> > +struct ewma*
> > +ewma_add(struct ewma *avg, const unsigned int val)
> > +{
> > +       avg->internal = avg->internal  ?
> > +               (((avg->internal * (avg->weight - 1)) +
> > +                       (val * avg->factor)) / avg->weight) :
> > +               (val * avg->factor);
> > +       return avg;
> > +}
> > +EXPORT_SYMBOL(ewma_add);
> 
> How can it be a weighted avg if each sample has the same weight?

by applying the weight again and again, we get an exponential weighting.

http://en.wikipedia.org/wiki/Exponentially_weighted_moving_average

bruno
