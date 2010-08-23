Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0HWNmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:42:03 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:35751 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751547Ab0HWNmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:42:02 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: rxLyUFsVM1lVR1k_5BzqetnX06xeil2sAXJvp4fI9djsOco
 63hABYEp4JZD4C9AIKMDfCD0GDH_hXftYtQ_8Q0cLTqqDyaIcnM9DUwzj0a3
 MTuScDze.eEpwU6phZSLLIH.zpQfcu9zF76jY3.0j5vH_P1Im4Cpxw._noRJ
 EN_il3vg8XsK0BSswWBBFmFokd_Te5V3qevijB0C5CcAkRQvOeg0_PHo_BO.
 t
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 23 Aug 2010 08:41:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <20100823130315.GQ19797@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1008230838320.5750@router.home>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <1282550442-15193-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1008230750380.4094@router.home> <20100823130315.GQ19797@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Mel Gorman wrote:

> > The delta of the counters could also be reduced to increase accuracy.
> > See refresh_zone_stat_thresholds().
> True, but I thought that would introduce a constant performance penalty
> for a corner case which I didn't like.

Sure, an increased frequency of updates would increase the chance of
bouncing cachelines. But the bouncing cacheline scenario for the vm
counters was tuned for applications that continually allocate pages in
parallel.

When the vm gets into a state where continual reclaim is necessary then
the counters are not that frequently updated. If the machine is already
slowing down due to reclaim then the vm can likely affort more frequent
counter updates.
