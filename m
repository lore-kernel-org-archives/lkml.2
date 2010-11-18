Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab0KRNjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:39:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46434 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766Ab0KRNjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:39:09 -0500
Date: Thu, 18 Nov 2010 08:39:04 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering writeback
Message-ID: <20101118133904.GB18834@infradead.org>
References: <1289996638-21439-1-git-send-email-walken@google.com>
 <1289996638-21439-4-git-send-email-walken@google.com>
 <20101117125756.GA5576@amd>
 <1290007734.2109.941.camel@laptop>
 <20101118054629.GA3339@amd>
 <2ADBEB7E-0EC8-4536-B556-0453A8E1D5FA@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ADBEB7E-0EC8-4536-B556-0453A8E1D5FA@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 05:43:06AM -0500, Theodore Tso wrote:
> Why is it at all important that mlock() force block allocation for sparse blocks?    It's  not at all specified in the mlock() API definition that it does that.
> 
> Are there really programs that assume that mlock() == fallocate()?!?

If there are programs that do they can't predate linux 2.6.15, and only
work on btrfs/ext4/xfs/etc, but not ext2/ext3/reiserfs.  Seems rather
unlikely to me.

