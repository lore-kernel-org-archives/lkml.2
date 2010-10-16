Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0JPHzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:55:07 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3752 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327Ab0JPHzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:55:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBA
Date: Sat, 16 Oct 2010 18:55:02 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] fs: Introduce per-bucket inode hash locks
Message-ID: <20101016075502.GG19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-13-git-send-email-david@fromorbit.com>
 <20100930015213.GA1535@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930015213.GA1535@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:52:14PM -0400, Christoph Hellwig wrote:
> 
> Instead of doing the lock overkill on a still fundamentally global data

How do you figure it is overkill?  Actually the hash insertion/removal
scales *really* well with per-bucket locks and it is a technique used
and proven in other parts of the kernel like networking.

Having a global lock there is certainly a huge bottleneck when you
start increasing system size, so I don't know why you keep arguing
against this.


> structure what about replacing this with something better.

I won't be doing this until after the scalability work.

> you've already done this with the XFS icache, and while the per-AG
> concept obviously can't be generic at least some of the lessons could be
> applied.
> 
> then again how much testing did this get anyway given that you
> benchmark ran mostly XFS which doesn't hit this at all?
> 
> If it was up to me I'd dtop this (and the bl_list addition) from the
> series for now and wait for people who care about the scalability of
> the generic icache code to come up with a better data structure.

I do care about scalability of icache code. Given how simple this
is, and seeing as we're about to have the big locking rework, I
much prefer just fixing all the global locks now (which need to
be fixed anyway).

