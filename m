Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab2IURwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab2IURwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:52:19 -0400
Date: Fri, 21 Sep 2012 14:52:05 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] mm: compaction: Acquire the zone->lock as late as
 possible
Message-ID: <20120921175204.GF6665@optiplex.redhat.com>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
 <1348224383-1499-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348224383-1499-7-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:46:20AM +0100, Mel Gorman wrote:
> Compactions free scanner acquires the zone->lock when checking for PageBuddy
> pages and isolating them. It does this even if there are no PageBuddy pages
> in the range.
> 
> This patch defers acquiring the zone lock for as long as possible. In the
> event there are no free pages in the pageblock then the lock will not be
> acquired at all which reduces contention on zone->lock.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---

Acked-by: Rafael Aquini <aquini@redhat.com>

