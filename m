Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab0FOQzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:55:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab0FOQzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:55:13 -0400
Date: Tue, 15 Jun 2010 18:54:42 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100615165442.GL28052@random.random>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
 <20100615140011.GD28052@random.random>
 <20100615141122.GA27893@infradead.org>
 <20100615142219.GE28052@random.random>
 <20100615144342.GA3339@infradead.org>
 <20100615150850.GF28052@random.random>
 <20100615153838.GO26788@csn.ul.ie>
 <20100615161419.GH28052@random.random>
 <20100615163044.GR26788@csn.ul.ie>
 <20100615163407.GS26788@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615163407.GS26788@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 05:34:07PM +0100, Mel Gorman wrote:
> My apologies. I didn't realise this was added so recently. I thought for
> a while already so....

It was also my fault I didn't grep with -r (as most fs layouts don't
have the writepage implementation under an inner linux-2.6/ dir ;),
but it's still recent it was added on Jun 03...

I wonder if anybody tested swapon ./swapfile_on_xfs after after such
change during heavy memory pressure leading to OOM (but not reaching
it).

Christoph says ext4 also does the same thing but lack of PF_MEMALLOC
check there rings a bell, can't judje without understanding ext4
better. Surely ext4 had more testing than this xfs of last week, so
taking ext4 as example is better idea if it does the same
thing. Taking the xfs change as example is not ok anymore considering
when it was added...

> I retract this point as well because in reality, we have little data on
> the full consequences of not writing pages from direct reclaim. Early
> data based on the tests I've run indicate that the number of pages
> direct reclaim writes is so small that it's not a problem but there is a
> strong case for adding throttling at least.

A "cp /dev/zero ." on xfs filesystem, during a gcc build on same xfs,
plus some swapping with swapfile over same xfs, sounds good test for
that. I doubt anybody run that considering how young that is.
