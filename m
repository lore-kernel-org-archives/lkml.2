Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0JON3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:29:44 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:45999 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545Ab0JON3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:29:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACrxt0x5Ld+3/2dsb2JhbAChIHK+LIVJBI9K
Date: Sat, 16 Oct 2010 00:29:38 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015132938.GA3936@amd>
References: <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
 <20101015105943.GE32255@dastard>
 <20101015130259.GA3207@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015130259.GA3207@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 12:03:00AM +1100, Nick Piggin wrote:
> On Fri, Oct 15, 2010 at 09:59:43PM +1100, Dave Chinner wrote:
> > My series uses i_lock only to protect i_state and i_ref. It does not
> > need to protect any more of the inode than that as other locks
> > protect the other list fields. As a result, it's still the inermost
> > lock and there are no trylocks in the code at all.
> We discussed it and I didn't think latencies would be any worse
> a problem than they are today. I agreed it may be an issue and
> pointed out there are ways forward to fix it.

BTW. if a few trylocks are your biggest issue, this is a joke. I told
you how they can be fixed with incremental patches on top of the series
(which basically whittle down the lock coverage of the old inode_lock,
and so IMO need to be done in small chunks well bisectable and with
good rationale). So why you didn't submit a couple of incremental
patches to do just that is beyond me.

I've had prototypes in my tree actually to do that from a while back,
but actually I'm thinking that using RCU may be a better way to go
now that Linus has agreed on it and we have sketched a design to do
slab-free-RCU.

Either way, it's much easier to compare pros and cons of each, when
they are done incrementally on top of the existing base.

