Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab0EFRad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:30:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:35897 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0EFRac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:30:32 -0400
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU
 utilization
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100506171141.GA5562@nowhere>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins>  <20100506171141.GA5562@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 19:30:24 +0200
Message-ID: <1273167024.1642.256.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 19:11 +0200, Frederic Weisbecker wrote:

> > But yeah, I did think of making the thing an RB-tree and basically
> > schedule on service received, that should fix the lop-sided RR we get
> > with constrained events.

> I don't understand what you mean by schedule on service received, and why
> an rbtree would solve that.

Schedule those events that got scheduled least, if because of
constraints we didn't fully utilize the PMU it is very likely that
strict RR (like we do now) will not end up giving equal service to each
counter/group.

Therefore, if you sort them in a tree, based on the amount of time they
got on the PMU, and always schedule the leftmost, you do get fairness.

Sure you can go add weights to them, but that's not the immediate goal.

