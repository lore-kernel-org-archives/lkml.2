Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab1I3Hl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:41:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab1I3Hl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:41:28 -0400
Date: Fri, 30 Sep 2011 09:41:25 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] oom: thaw threads if oom killed thread is frozen before
 deferring
Message-ID: <20110930074125.GB32134@tiehlicka.suse.cz>
References: <cover.1317110948.git.mhocko@suse.cz>
 <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz>
 <alpine.DEB.2.00.1109271133590.17876@chino.kir.corp.google.com>
 <20110928104445.GB15062@tiehlicka.suse.cz>
 <20110929115105.GE21113@tiehlicka.suse.cz>
 <20110929120517.GA10587@redhat.com>
 <20110929130204.GG21113@tiehlicka.suse.cz>
 <20110929163724.GA23773@redhat.com>
 <20110929180021.GA27999@tiehlicka.suse.cz>
 <20110930015148.GD10425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930015148.GD10425@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29-09-11 18:51:48, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 29, 2011 at 08:00:21PM +0200, Michal Hocko wrote:
> > > I meant, oom_kill can do this before thaw thaw_process(), afaics
> > > this should fix the particular race you described (but not others).
> > 
> > This is what the follow up fix from David is doing. Check frozen in
> > select_bad_process if the task is TIF_MEMDIE and thaw the process.
> > 
> > And it seems that the David's follow up fix is sufficient so let's leave
> > refrigerator alone.
> > Or am I still missing something?
> 
> With pending freezer changes, allowing TIF_MEMDIE tasks to exit
> freezer by modifying freezing() shouldn't be difficult, which should
> be race-free and much simpler than diddling with thaw_task().  

Will the rework help with the initial problem of unkillable OOM selected
frozen tasks or it will just help with other races that might be present
with the patch? In other words will this work deprecate the 2 patches
sent earlier in this thread?

> How urgent is this?  Can we wait for the next merge window?

Yes, I think we can wait some more.

> 
> Thanks.
> 
> -- 
> tejun
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
