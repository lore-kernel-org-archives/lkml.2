Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2KUI1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:27:44 -0500
Received: from mx2.parallels.com ([64.131.90.16]:47805 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab2KUI1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:27:42 -0500
Message-ID: <50AC9070.2030009@parallels.com>
Date: Wed, 21 Nov 2012 12:27:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>,
        <linux-man@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
References: <20121107105348.GA25549@lizard> <20121107112136.GA31715@shutemov.name> <CAOJsxLHY+3ZzGuGX=4o1pLfhRqjkKaEMyhX0ejB5nVrDvOWXNA@mail.gmail.com> <20121107114321.GA32265@shutemov.name> <alpine.DEB.2.00.1211141910050.14414@chino.kir.corp.google.com> <20121115033932.GA15546@lizard.sbx05977.paloaca.wayport.net> <alpine.DEB.2.00.1211141946370.14414@chino.kir.corp.google.com> <20121115073420.GA19036@lizard.sbx05977.paloaca.wayport.net> <alpine.DEB.2.00.1211142351420.4410@chino.kir.corp.google.com> <20121115085224.GA4635@lizard> <alpine.DEB.2.00.1211151303510.27188@chino.kir.corp.google.com> <50A60873.3000607@parallels.com> <alpine.DEB.2.00.1211161157390.2788@chino.kir.corp.google.com> <50A6AC48.6080102@parallels.com> <alpine.DEB.2.00.1211161349420.17853@chino.kir.corp.google.com> <50AA3FEF.2070100@parallels.com> <alpine.DEB.2.00.1211201013460.4200@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211201013460.4200@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 10:23 PM, David Rientjes wrote:
> Anton can correct me if I'm wrong, but I certainly don't think this is 
> where mempressure is headed: I don't think any accounting needs to be done 
> and, if it is, it's a design issue that should be addressed now rather 
> than later.  I believe notifications should occur on current's mempressure 
> cgroup depending on its level of reclaim: nobody cares if your memcg has a 
> limit of 64GB when you only have 32GB of RAM, we'll want the notification.

My main concern is that to trigger those notifications, one would have
to first determine whether or not the particular group of tasks is under
pressure. And to do that, we need to somehow know how much memory we are
using, and how much we are reclaiming, etc. On a system-wide level, we
have this information. On a grouplevel, this is already accounted by memcg.

In fact, the current code already seems to rely on memcg:

+	vmpressure(sc->target_mem_cgroup,
+		   sc->nr_scanned - nr_scanned, nr_reclaimed);

Now, let's start simple: Assume we will have a different cgroup.
We want per-group pressure notifications for that group. How would you
determine that the specific group is under pressure?


