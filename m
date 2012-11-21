Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2KULzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:55:00 -0500
Received: from mx2.parallels.com ([64.131.90.16]:57219 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab2KULy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:54:58 -0500
Message-ID: <50ACC104.5060006@parallels.com>
Date: Wed, 21 Nov 2012 15:54:44 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: <leonid.moiseichuk@nokia.com>
CC: <kirill@shutemov.name>, <rientjes@google.com>,
        <anton.vorontsov@linaro.org>, <penberg@kernel.org>, <mgorman@suse.de>,
        <kosaki.motohiro@gmail.com>, <minchan@kernel.org>,
        <b.zolnierkie@samsung.com>, <john.stultz@linaro.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <kernel-team@android.com>, <linux-man@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <mhocko@suse.cz>,
        <hannes@cmpxchg.org>, <tj@kernel.org>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
References: <20121115073420.GA19036@lizard.sbx05977.paloaca.wayport.net> <alpine.DEB.2.00.1211142351420.4410@chino.kir.corp.google.com> <20121115085224.GA4635@lizard> <alpine.DEB.2.00.1211151303510.27188@chino.kir.corp.google.com> <50A60873.3000607@parallels.com> <alpine.DEB.2.00.1211161157390.2788@chino.kir.corp.google.com> <50A6AC48.6080102@parallels.com> <alpine.DEB.2.00.1211161349420.17853@chino.kir.corp.google.com> <50AA3ABF.4090803@parallels.com> <alpine.DEB.2.00.1211200950120.4200@chino.kir.corp.google.com> <20121121093056.GA31882@shutemov.name> <84FF21A720B0874AA94B46D76DB982690469CC00@008-AM1MPN1-002.mgdnok.nokia.com>
In-Reply-To: <84FF21A720B0874AA94B46D76DB982690469CC00@008-AM1MPN1-002.mgdnok.nokia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>
> Memory notifications are quite irrelevant to partitioning and cgroups. The use-case is related to user-space handling low memory. Meaning the functionality should be accurate with specific granularity (e.g. 1 MB) and time (0.25s is OK) but better to have it as simple and battery-friendly. I prefer to have pseudo-device-based  text API because it is easy to debug and investigate. It would be nice if it will be possible to use simple scripting to point what kind of memory on which levels need to be tracked but private/shared dirty is #1 and memcg cannot handle it.
>
If that is the case, then fine.
The reason I jumped in talking about memcg, is that it was mentioned
that at some point we'd like to have those notifications on a per-group
basis.

So I'll say it again: if this is always global, there is no reason any
cgroup needs to be involved. If this turns out to be per-process, as
Anton suggested in a recent e-mail, I don't see any reason to have
cgroups involved as well.

But if this needs to be extended to be per-cgroup, then past experience
shows that we need to be really careful not to start duplicating
infrastructure, and creating inter-dependencies like it happened to
other groups in the past.
