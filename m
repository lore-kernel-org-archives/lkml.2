Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1HRXzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 19:55:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab1HRXzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 19:55:14 -0400
Date: Thu, 18 Aug 2011 16:54:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/7] Reduce filesystem writeback from page reclaim v3
Message-Id: <20110818165420.0a7aabb5.akpm@linux-foundation.org>
In-Reply-To: <1312973240-32576-1-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 11:47:13 +0100
Mel Gorman <mgorman@suse.de> wrote:

> The new problem is that
> reclaim has very little control over how long before a page in a
> particular zone or container is cleaned which is discussed later.

Confused - where was this discussed?  Please tell us more about
this problem and how it was addressed.


Another (and somewhat interrelated) potential problem I see with this
work is that it throws a big dependency onto kswapd.  If kswapd gets
stuck somewhere for extended periods, there's nothing there to perform
direct writeback.  This has happened in the past in weird situations
such as kswpad getting blocked on ext3 journal commits which are
themselves stuck for ages behind lots of writeout which itself is stuck
behind lots of reads.  That's an advantage of direct reclaim: more
threads available.

How forcefully has this stuff been tested with multiple disks per
kswapd?  Where one disk is overloaded-ext3-on-usb-stick?

