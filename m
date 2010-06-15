Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0FOOLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:11:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab0FOOL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:11:29 -0400
Date: Tue, 15 Jun 2010 10:11:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100615141122.GA27893@infradead.org>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
 <20100615140011.GD28052@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615140011.GD28052@random.random>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 04:00:11PM +0200, Andrea Arcangeli wrote:
> collecting clean cache doesn't still satisfy the allocation), during
> allocations in direct reclaim and increase the THREAD_SIZE than doing
> this purely for stack reasons as the VM will lose reliability if we

This basically means doubling the stack size, as you can splice together
two extremtly stack hungry codepathes in the worst case.  Do you really
want order 2 stack allocations?

