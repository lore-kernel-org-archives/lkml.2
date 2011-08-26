Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1HZKsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:48:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1HZKs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:48:29 -0400
Date: Fri, 26 Aug 2011 12:48:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] oom: skip frozen tasks
Message-ID: <20110826104827.GC9083@tiehlicka.suse.cz>
References: <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com>
 <20110824101927.GB3505@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com>
 <20110825091920.GA22564@tiehlicka.suse.cz>
 <20110825151818.GA4003@redhat.com>
 <20110825164758.GB22564@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
 <20110826070946.GA7280@tiehlicka.suse.cz>
 <20110826085610.GA9083@tiehlicka.suse.cz>
 <4E576F65.5060009@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E576F65.5060009@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 26-08-11 14:03:17, Konstantin Khlebnikov wrote:
> Michal Hocko wrote:
> 
> >@@ -450,6 +459,10 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
> >  			pr_err("Kill process %d (%s) sharing same memory\n",
> >  				task_pid_nr(q), q->comm);
> >  			task_unlock(q);
> >+
> >+			if (frozen(q))
> >+				thaw_process(q);
> >+
> 
> We must thaw task strictly after sending SIGKILL.

Sounds reasonable.

> But anyway I think this is a bad idea.

Why?

> 
> >  			force_sig(SIGKILL, q);
> >  		}
> >

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
