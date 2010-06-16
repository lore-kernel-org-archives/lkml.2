Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0FPFIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:08:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab0FPFIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:08:04 -0400
Date: Wed, 16 Jun 2010 01:07:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100616050757.GB10687@infradead.org>
References: <1276514273-27693-13-git-send-email-mel@csn.ul.ie>
 <4C16A567.4080000@redhat.com>
 <20100615114510.GE26788@csn.ul.ie>
 <4C17815A.8080402@redhat.com>
 <20100615135928.GK26788@csn.ul.ie>
 <4C178868.2010002@redhat.com>
 <20100615141601.GL26788@csn.ul.ie>
 <20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com>
 <4C181AFD.5060503@redhat.com>
 <20100616093958.00673123.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616093958.00673123.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 09:39:58AM +0900, KAMEZAWA Hiroyuki wrote:
> Hmm. But I don't expect copy_from/to_user is called in very deep stack.

Actually it is.  The poll code mentioned earlier in this thread is just
want nasty example.  I'm pretty sure there are tons of others in ioctl
code, as various ioctl implementations have been found to be massive
stack hogs in the past, even worse for out of tree drivers.

