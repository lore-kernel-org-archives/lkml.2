Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab1LWNkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:40:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192Ab1LWNj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:39:59 -0500
Date: Fri, 23 Dec 2011 14:39:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        devel@openvz.org, Dave Jones <davej@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] move get_idle_time , get_iowait_time to sched/core.c
Message-ID: <20111223133956.GC26157@tiehlicka.suse.cz>
References: <1323682263-1310-1-git-send-email-glommer@parallels.com>
 <4EF45309.7060005@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF45309.7060005@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 23-12-11 14:08:09, Glauber Costa wrote:
> On 12/12/2011 01:31 PM, Glauber Costa wrote:
> >In commit a25cac5198 we changed the way we calculate idle and iowait
> >for /proc/stat displaying purposes. However, this same information
> >is also displayed in /proc/uptime. These values can now be inconsistent.
> >
> >So I propose we draw both idle values from the same place. In theory,
> >we only need to do it for get_idle_time(). get_iowait_time() is moved
> >as well for consistency only.
> >
> >I moved the functions to sched/core.c so it can live among its other
> >friends like nr_iowait(), etc.
> >
> 
> You guys have any opinions on this ?
> I see that Michal got another fix for this in stat.c already, so I'd
> have to respin this one anyway. Just let me know if this is wanted

The last follow up fix is in Andrew's tree at the moment: procfs: do not
confuse jiffies with cputime64_t.

I don't mind moving those functions outside stat.c if it is reused.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
