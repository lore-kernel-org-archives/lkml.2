Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab0KRNhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:37:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0KRNhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:37:16 -0500
Date: Thu, 18 Nov 2010 08:37:02 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering writeback
Message-ID: <20101118133702.GA18834@infradead.org>
References: <1289996638-21439-1-git-send-email-walken@google.com>
 <1289996638-21439-4-git-send-email-walken@google.com>
 <20101117125756.GA5576@amd>
 <1290007734.2109.941.camel@laptop>
 <AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
 <20101117231143.GQ22876@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117231143.GQ22876@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:11:43AM +1100, Dave Chinner wrote:
> Hence I think that avoiding ->page_mkwrite callouts is likely to
> break some filesystems in subtle, undetected ways.  IMO, regardless
> of what is done, it would be really good to start by writing a new
> regression test to exercise and encode the expected the mlock
> behaviour so we can detect regressions later on....

I think it would help if we could drink a bit of the test driven design
coolaid here. Michel, can you write some testcases where pages on a
shared mapping are mlocked, then dirtied and then munlocked, and then
written out using msync/fsync.  Anything that fails this test on
btrfs/ext4/gfs/xfs/etc obviously doesn't work.

