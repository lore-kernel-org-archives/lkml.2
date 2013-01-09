Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab3AIUhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:37:50 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33978 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069Ab3AIUhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:38 -0500
Date: Wed, 9 Jan 2013 12:37:31 -0800
From: Tejun Heo <tj@kernel.org>
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
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 1/2] Add mempressure cgroup
Message-ID: <20130109203731.GA20454@htj.dyndns.org>
References: <20130104082751.GA22227@lizard.gateway.2wire.net>
 <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Can you please cc me too when posting further patches?  I kinda missed
the whole discussion upto this point.

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

So, cgroup is headed towards single hierarchy.  Dunno how much it
would affect mempressure but it probably isn't wise to design with
focus on multiple hierarchies.

Isn't memory reclaim and oom condition tied to memcgs when memcg is in
use?  It seems natural to tie mempressure to memcg.  Is there some
reason this should be a separate cgroup.  I'm kinda worried this is
headed cpuacct / cpu silliness we have.  Glauber, what's your opinion
here?

Thanks.

-- 
tejun
