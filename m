Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab0KQXwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:52:43 -0500
Received: from THUNK.ORG ([69.25.196.29]:60798 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab0KQXwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:52:42 -0500
Date: Wed, 17 Nov 2010 18:52:30 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering
 writeback
Message-ID: <20101117235230.GL3290@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Michel Lespinasse <walken@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Piggin <npiggin@kernel.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
	Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
	Suleiman Souhlal <suleiman@google.com>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:11:43AM +1100, Dave Chinner wrote:
> I don't think ->page_mkwrite can be worked around - we need that to
> be called on the first write fault of any mmap()d page to ensure it
> is set up correctly for writeback.  If we don't get write faults
> after the page is mlock()d, then we need the ->page_mkwrite() call
> during the mlock() call.

OK, so I'm not an mm hacker, so maybe I'm missing something.  Could
part of this be fixed by simply sending the write faults for
mlock()'ed pages, so page_mkwrite() gets called when the page is
dirtied.  Seems like a real waste to have the file system pre-allocate
all of the blocks for a mlock()'ed region.  Why does mlock() have to
result in the write faults getting suppressed when the page is
actually dirtied?

						- Ted
