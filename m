Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab1IAEjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 00:39:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55882 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1IAEjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 00:39:52 -0400
Date: Thu, 1 Sep 2011 06:39:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901043947.GB7761@one.firstfloor.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com> <20110830053231.GA1627@infradead.org> <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com> <20110831052627.GA5338@infradead.org> <m2pqjlo6e5.fsf@firstfloor.org> <20110901041848.GO32358@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901041848.GO32358@dastard>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Allocations are already serialised by a single resource - the AGF
> lock - so whether they block on the workqueue queue or on the AGF
> lock is irrelevant to scheduling. And a single thread can only have

It's not about blocking, but about who gets the work accounted
when it is done.

> If we get lots of allocations queued on the one per-CPU wq, they
> will have all had to come from different contexts. In which case,
> FIFO processing of the work queued up is *exactly* the fairness we
> want, because that is exactly what doing them from process context
> would end up with.

You want the work accounted to the originator so that it can be
slowed down when it does too much (e.g. hit its cgroups or CFQ limits)

Networking learned these lessons a long time ago, it's much 
better for overload behavior when as much as possible is done in
process context.

-Andi
