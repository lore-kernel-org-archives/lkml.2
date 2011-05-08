Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1EHOx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:53:29 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40494 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1EHOx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:53:28 -0400
Date: Sun, 8 May 2011 07:53:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH] RCU: remove alignment padding from rcu_data on 64 bit
 builds
Message-ID: <20110508145323.GS2641@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1304610604.1984.6.camel@castor.rsk>
 <1304662845.3131.23.camel@edumazet-laptop>
 <1304684036.1998.10.camel@castor.rsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304684036.1998.10.camel@castor.rsk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 01:13:56PM +0100, Richard Kennedy wrote:
> On Fri, 2011-05-06 at 08:20 +0200, Eric Dumazet wrote:
> ...
> > We could shrink this structure more, converting some 64bit fields to
> > 32bit ones.
> > 
> > Rationale is the algo is working well on 32bit arches, no need to use
> > 64bit fields.
> > 
> > candidates : completed, gpnum, passed_quiesc_completed, qlen,
> > qlen_last_fqs_check, blimit.
> > 
> > Counters might be converted too.
> 
> I don't know the code well enough to make that decision ;)
> Is it possible to shrink it enough to free up another cache line ?
> (16 longs to ints).

A number of these could be changed from long to int, though appropriate
adjustments need to be made.  Some of the fields could be placed under
#ifdef CONFIG_RCU_TRACE, though again, corresponding adjustments would
need to be made.

> CONFIG_NO_HZ adds 24 bytes so even for users with !CONFIG_NO_HZ the
> variables you suggest are not enough to free a cache line.  

Yep.  And recent work introducing RCU priority boosting adds some more.

But it is not like this structure is allocated as a unit, so are you
really all that sensitive to the exact size?

							Thanx, Paul
