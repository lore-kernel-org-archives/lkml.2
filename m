Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab1GTTTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:19:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1GTTTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:19:02 -0400
Date: Wed, 20 Jul 2011 20:18:58 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
Message-ID: <20110720191858.GO5349@suse.de>
References: <1310742540-22780-1-git-send-email-mgorman@suse.de>
 <1310742540-22780-2-git-send-email-mgorman@suse.de>
 <alpine.DEB.2.00.1107180951390.30392@router.home>
 <20110718160552.GB5349@suse.de>
 <alpine.DEB.2.00.1107181208050.31576@router.home>
 <20110718211325.GC5349@suse.de>
 <alpine.DEB.2.00.1107181651000.31576@router.home>
 <alpine.DEB.2.00.1107190901120.1199@router.home>
 <alpine.DEB.2.00.1107201307530.1472@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107201307530.1472@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 01:08:46PM -0500, Christoph Lameter wrote:
> Hmmm... Looking at get_page_from_freelist and considering speeding that up
> in general: Could we move the whole watermark logic into the slow path?
> Only check when we refill the per cpu queues?

Each CPU list can hold 186 pages (on my currently running
kernel at least) which is 744K. As I'm running with THP enabled,
the min watermark is 25852K so with 34 of more CPUs, there is a
risk that a zone would be fully depleted due to lack of watermark
checking. Bit unlikely that 34 CPUs would be on one node but the risk
is there. Without THP, the min watermark would have been something like
32K where it would be much easier to accidentally consume all memory.

Yes, moving the watermark checks to the slow path would be faster
but under some conditions, the system will lock up.

-- 
Mel Gorman
SUSE Labs
