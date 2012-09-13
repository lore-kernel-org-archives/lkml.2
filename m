Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2IMKRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:17:33 -0400
Received: from [205.233.59.134] ([205.233.59.134]:58375 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab2IMKR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:17:27 -0400
Message-ID: <1347531392.15764.119.camel@twins>
Subject: Re: [PATCH] lockdep: Check if nested lock is actually held
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Sep 2012 12:16:32 +0200
In-Reply-To: <5051B101.4030806@canonical.com>
References: <5051A9E7.5040501@canonical.com>
	 <1347530393.15764.115.camel@twins> <5051B101.4030806@canonical.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 12:10 +0200, Maarten Lankhorst wrote:
> Hey,
> 
> Op 13-09-12 11:59, Peter Zijlstra schreef:
> > On Thu, 2012-09-13 at 11:39 +0200, Maarten Lankhorst wrote:
> >> It is considered good form to lock the lock you claim to be nested in.
> > Uhm yeah.. cute. You actually found a site where this triggered?
> >
> Not in mainline, I was working on some lockdep annotations for my work on
> moving ttm reservations to base kernel, and I wrote a whole bunch of tests
> to stress interaction between reservations and locks, one of the tests I
> was doing was taking a spinlock without the nested object:
> 
> static void reservation_test_fence_nest_unreserved(void)
> {
> 	struct reservation_object o;
> 
> 	reservation_object_init(&o);
> 
> 	spin_lock_nest_lock(&o.fence_lock, &o);
> 	spin_unlock(&o.fence_lock);
> }
> 
> I would have expected it to fail, and the patch fixed it. As a nice side effect
> it also complained about another hack I was doing elsewhere with reservations to
> tests for deadlocks, and it forced me to fix it in a slightly less hacky way.

Nice.. thanks for noticing!
