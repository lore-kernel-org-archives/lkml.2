Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab0FPRFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:05:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759055Ab0FPRFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:05:31 -0400
Date: Wed, 16 Jun 2010 19:04:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Hellwig <hch@infradead.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100616170446.GI5816@random.random>
References: <20100615144342.GA3339@infradead.org>
 <20100615150850.GF28052@random.random>
 <20100615152526.GA3468@infradead.org>
 <20100615154516.GG28052@random.random>
 <20100615162600.GA9910@infradead.org>
 <4C17AF2D.2060904@redhat.com>
 <20100615165423.GA16868@infradead.org>
 <4C17D0C5.9030203@redhat.com>
 <20100616075723.GT6138@laptop>
 <4C19030A.4070406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C19030A.4070406@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 12:59:54PM -0400, Rik van Riel wrote:
> __GFP_IO can wait for filesystem activity

Hmm I think it's for submitting I/O, not about waiting. At some point
you may not enter the FS because of the FS locks you already hold
(like within writepage itself), but you can still submit I/O through
blkdev layer.

> __GFP_FS can kick off new filesystem activity

Yes that's for dcache/icache/writepage or anything that can reenter
the fs locks and deadlock IIRC.
