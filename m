Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3AHIty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:49:54 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47661 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3AHItw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:49:52 -0500
X-AuditID: 9c930197-b7c5bae000000e31-0c-50ebddae2e69
Date: Tue, 8 Jan 2013 17:49:49 +0900
From: Minchan Kim <minchan@kernel.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 1/2] Add mempressure cgroup
Message-ID: <20130108084949.GD4714@blaptop>
References: <20130104082751.GA22227@lizard.gateway.2wire.net>
 <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Fri, Jan 04, 2013 at 12:29:11AM -0800, Anton Vorontsov wrote:
> This commit implements David Rientjes' idea of mempressure cgroup.
> 
> The main characteristics are the same to what I've tried to add to vmevent
> API; internally, it uses Mel Gorman's idea of scanned/reclaimed ratio for
> pressure index calculation. But we don't expose the index to the userland.
> Instead, there are three levels of the pressure:
> 
>  o low (just reclaiming, e.g. caches are draining);
>  o medium (allocation cost becomes high, e.g. swapping);
>  o oom (about to oom very soon).
> 
> The rationale behind exposing levels and not the raw pressure index
> described here: http://lkml.org/lkml/2012/11/16/675
> 
> For a task it is possible to be in both cpusets, memcg and mempressure
> cgroups, so by rearranging the tasks it is possible to watch a specific
> pressure (i.e. caused by cpuset and/or memcg).
> 
> Note that while this adds the cgroups support, the code is well separated
> and eventually we might add a lightweight, non-cgroups API, i.e. vmevent.
> But this is another story.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Sorry still I didn't look at your implementation about cgroup part.
but I had a question since long time ago.

How can we can make sure false positive about zone and NUMA?
I mean DMA zone is short in system so VM notify to user and user
free all memory of NORMAL zone because he can't know what pages live
in any zones. NUMA is ditto.

-- 
Kind regards,
Minchan Kim
