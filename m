Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0KRRlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:41:37 -0500
Received: from smtp-out.google.com ([74.125.121.35]:11182 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349Ab0KRRlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:41:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=XD89Ltm3RdOfyF1tiilRlMqcvYwUWpX4T5uo3wQ/84+LhpTNnDqg3hUoYIfc/EeB4M
         k16/jy00eUEddcY86jbw==
Date: Thu, 18 Nov 2010 09:41:22 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Christoph Hellwig <hch@infradead.org>
cc: Dave Chinner <david@fromorbit.com>, Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering
 writeback
In-Reply-To: <20101118133702.GA18834@infradead.org>
Message-ID: <alpine.LSU.2.00.1011180934400.3210@tigran.mtv.corp.google.com>
References: <1289996638-21439-1-git-send-email-walken@google.com> <1289996638-21439-4-git-send-email-walken@google.com> <20101117125756.GA5576@amd> <1290007734.2109.941.camel@laptop> <AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
 <20101117231143.GQ22876@dastard> <20101118133702.GA18834@infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Christoph Hellwig wrote:
> On Thu, Nov 18, 2010 at 10:11:43AM +1100, Dave Chinner wrote:
> > Hence I think that avoiding ->page_mkwrite callouts is likely to
> > break some filesystems in subtle, undetected ways.  IMO, regardless
> > of what is done, it would be really good to start by writing a new
> > regression test to exercise and encode the expected the mlock
> > behaviour so we can detect regressions later on....
> 
> I think it would help if we could drink a bit of the test driven design
> coolaid here. Michel, can you write some testcases where pages on a
> shared mapping are mlocked, then dirtied and then munlocked, and then
> written out using msync/fsync.  Anything that fails this test on
> btrfs/ext4/gfs/xfs/etc obviously doesn't work.

Whilst it's hard to argue against a request for testing, Dave's worries
just sprang from a misunderstanding of all the talk about "avoiding ->
page_mkwrite".  There's nothing strange or risky about Michel's patch,
it does not avoid ->page_mkwrite when there is a write: it just stops
pretending that there was a write when locking down the shared area.

Hugh
