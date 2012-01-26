Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2AZIyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 03:54:11 -0500
Received: from shutemov.name ([176.9.204.213]:40889 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2AZIyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 03:54:09 -0500
Date: Thu, 26 Jan 2012 10:54:48 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-mm@kvack.org, "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: fix compile warning on non-numa systems
Message-ID: <20120126085448.GA32013@shutemov.name>
References: <4F13BE05.70505@cn.fujitsu.com>
 <20120116084715.GA1639@tiehlicka.suse.cz>
 <20120126005521.07ac0faf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126005521.07ac0faf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 12:55:21AM -0800, Andrew Morton wrote:
> On Mon, 16 Jan 2012 09:47:15 +0100 Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Mon 16-01-12 14:04:53, Li Zefan wrote:
> > > Fix this warning:
> > > 
> > >   CC      mm/memcontrol.o
> > > mm/memcontrol.c: In function 'memcg_check_events':
> > > mm/memcontrol.c:779:22: warning: unused variable 'do_numainfo'
> > 
> > This has been already posted by Kirill and I didn't like the solution
> > (https://lkml.org/lkml/2011/12/27/86). He then reposted with a different
> > version (https://lkml.org/lkml/2012/1/6/281).
> > The later one looks better but I still think this is not worth
> > complicate the code just to get rid of this warning.
> 
> This?
> 
> --- a/mm/memcontrol.c~a
> +++ a/mm/memcontrol.c
> @@ -776,7 +776,8 @@ static void memcg_check_events(struct me
>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit, do_numainfo;
> +		bool do_softlimit;
> +		bool do_numainfo __maybe_unused;
>  
>  		do_softlimit = mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_SOFTLIMIT);
> _

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
