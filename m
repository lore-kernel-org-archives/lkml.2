Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1GVPBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:01:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58102
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623Ab1GVPBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:01:54 -0400
Date: Fri, 22 Jul 2011 11:01:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, linux-kernel@vger.kernel.org,
        david@fromorbit.com
Subject: rw_semaphore performance, was: new metadata reader/writer locks in
 integration-test
Message-ID: <20110722150151.GA23686@infradead.org>
References: <1311096438-sup-1263@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311096438-sup-1263@shiny>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 01:30:22PM -0400, Chris Mason wrote:
> We've seen a number of benchmarks dominated by contention on the root
> node lock.  This changes our locks into a simple reader/writer lock.
> They are based on mutexes so that we still take advantage of the mutex
> adaptive spins for write locks (rwsemaphores were much slower).

Interesting.  Do you have set up some artifical benchmarks for this?

I wonder if the lack of adaptive spinning has something to do with the
slightly slower XFS performance on Joern's flash testing, given that
we extensively use the rw_semaphore as the primary I/O mutex, while
all others rely on plain mutexes as the primary synchronization
primitive.
