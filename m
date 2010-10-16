Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0JPH5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:57:13 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41809 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464Ab0JPH5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:57:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:57:09 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] fs: Protect inode->i_state with th einode->i_lock
Message-ID: <20101016075709.GP19147@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-15-git-send-email-david@fromorbit.com>
 <20101008074932.GC24089@infradead.org>
 <20101008080428.GW4681@dastard>
 <20101008081843.GB17577@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008081843.GB17577@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:18:43AM -0400, Christoph Hellwig wrote:
> > 
> > Ah, done thinking now! I was so the i_state field had been set
> > before the inode was added to various lists and potentially
> > accessable to other threads. I should probably add a comment to that
> > effect, right?
> 
> Yes, please.

This is due to i_lock not covering all the icache state of the inode,
so you have to make these synchronisation changes like this.

I much prefer such proposals to go at the end of my series, where I
will probably nack them (and use rcu instead if the remaining trylocks
are such a big issue).

