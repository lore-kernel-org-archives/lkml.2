Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab1GSEH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:07:26 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36798 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032Ab1GSEHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:07:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8DAC8AJU55LCkBgWdsb2JhbABTp0kVAQEWJiXNZw6FT18EmxKIPw
Date: Tue, 19 Jul 2011 14:07:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 0/2] splice: i_mutex vs splice write deadlock
Message-ID: <20110719040721.GE31294@dastard>
References: <1310961884-11634-1-git-send-email-david@fromorbit.com>
 <20110719031003.GA18166@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719031003.GA18166@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:10:03PM -0400, Christoph Hellwig wrote:
> I don't really like this very much.  Not taking the i_mutex at all
> makes the splice_write method in XFS use different locking than
> everyone else, and different from the normal XFS write path.
> 
> For example ocfs2 which has the same locking issues just has an
> own implementation of the splice_write method, which isn't
> too nice but at least marginally better.  I think the right
> fix for both xfs and ocfs2 would be to have a generic_file_splice_write
> variant that takes an "actor" function pointer, which defaults to
> a smaller wrapper around file_remove_suid, file_update_time and
> splice_from_pipe_feed, and then XFS and ocfs2 can provide their
> own actors that add the additional locking.

Yeah I thought about doing that, but wanted to try a simpler version
first. I'll code up the actor variant.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
