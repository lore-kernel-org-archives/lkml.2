Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab0EUPP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:15:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab0EUPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:15:23 -0400
Date: Fri, 21 May 2010 11:15:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100521151518.GA12752@infradead.org>
References: <20100512212403.GE3597@localhost.localdomain> <20100513013926.GD27011@dhcp231-156.rdu.redhat.com> <20100514010042.GI13617@dastard> <20100514033057.GL27011@dhcp231-156.rdu.redhat.com> <20100514064145.GJ13617@dastard> <20100514072219.GC4706@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514072219.GC4706@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick, what exactly is the problem with the reserve + allocate design?

In a delalloc filesystem (which is all those that will care about high
performance large writes) the write path fundamentally consists of those
two operations.  Getting rid of the get_blocks mess and replacing it
with a dedicated operations vector will simplify things a lot.

Punching holes is a rather problematic operation, and as mentioned not
actually implemented for most filesystems - just decrementing counters
on errors increases the chances that our error handling will actually
work massively.


