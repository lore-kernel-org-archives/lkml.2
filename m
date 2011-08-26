Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab1HZVBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:01:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41222 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab1HZVBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:01:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] oom: skip frozen tasks
Date: Fri, 26 Aug 2011 23:03:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Michal Hocko <mhocko@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20110823073101.6426.77745.stgit@zurg> <20110826085610.GA9083@tiehlicka.suse.cz> <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108262303.38923.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 26, 2011, David Rientjes wrote:
> On Fri, 26 Aug 2011, Michal Hocko wrote:
> 
> > Let's give all frozen tasks a bonus (OOM_SCORE_ADJ_MAX/2) so that we do
> > not consider them unless really necessary and if we really pick up one
> > then thaw its threads before we try to kill it.
> > 
> 
> I don't like arbitrary heuristics like this because they polluted the old 
> oom killer before it was rewritten and made it much more unpredictable.  
> The only heuristic it includes right now is a bonus for root tasks so that 
> when two processes have nearly the same amount of memory usage (within 3% 
> of available memory), the non-root task is chosen instead.
> 
> This bonus is actually saying that a single frozen task can use up to 50% 
> more of the machine's capacity in a system-wide oom condition than the 
> task that will now be killed instead.  That seems excessive.
> 
> I do like the idea of automatically thawing the task though and if that's 
> possible then I don't think we need to manipulate the badness heuristic at 
> all.  I know that wouldn't be feasible when we've frozen _all_ threads and 
> that's why we have oom_killer_disable(), but we'll have to check with 
> Rafael to see if something like this could work.  Rafael?

That depends a good deal on when the thawing happens and what the thawed
task can do before being killed.  For example, if the thawing happens
while devices are suspended and the thawed task accesses a driver through
ioctl(), for example, the purpose of freezing will be defeated.

Thanks,
Rafael
