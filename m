Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1A0Jyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 04:54:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50803 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab1A0Jyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 04:54:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Jan 2011 18:48:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, stable@kernel.org
Subject: Re: [PATCH] memsw: handle swapaccount kernel parameter correctly
Message-Id: <20110127184827.a8927595.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110127092951.GA8036@tiehlicka.suse.cz>
References: <20110126152158.GA4144@tiehlicka.suse.cz>
	<20110126140618.8e09cd23.akpm@linux-foundation.org>
	<20110127082320.GA15500@tiehlicka.suse.cz>
	<20110127180330.78585085.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127092951.GA8036@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 10:29:51 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 27-01-11 18:03:30, KAMEZAWA Hiroyuki wrote:
> > On Thu, 27 Jan 2011 09:23:20 +0100
> > Michal Hocko <mhocko@suse.cz> wrote:
> [...]
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index db76ef7..cea2be48 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -5013,9 +5013,9 @@ struct cgroup_subsys mem_cgroup_subsys = {
> > >  static int __init enable_swap_account(char *s)
> > >  {
> > >  	/* consider enabled if no parameter or 1 is given */
> > > -	if (!s || !strcmp(s, "1"))
> > > +	if (!(*s) || !strcmp(s, "=1"))
> > >  		really_do_swap_account = 1;
> > > -	else if (!strcmp(s, "0"))
> > > +	else if (!strcmp(s, "=0"))
> > >  		really_do_swap_account = 0;
> > >  	return 1;
> > >  }
> > 
> > Hmm, usual callser of __setup() includes '=' to parameter name, as
> > 
> > mm/hugetlb.c:__setup("hugepages=", hugetlb_nrpages_setup);
> > mm/hugetlb.c:__setup("default_hugepagesz=", hugetlb_default_setup);
> > 
> > How about moving "=" to __setup() ?
> 
> I have considered that as well but then we couldn't use swapaccount
> parameter without any value because the parameter parsing matches the
> whole string. 
> I found it better to have consistent [no]swapaccount with the =0|1
> extension rather than keeping = in the setup like other users.
> 
> Sounds reasonable?

Hmm. ok for this time.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Could you try to write a patch for feature-removal-schedule.txt
and tries to remove noswapaccount and do clean up all ?
(And add warning to noswapaccount will be removed.....in 2.6.40)


Thanks,
-Kame




