Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3AIM6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 07:58:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506Ab3AIM6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 07:58:05 -0500
Date: Wed, 9 Jan 2013 13:57:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        gthelen@google.com, fengguang.wu@intel.com, glommer@parallels.com,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V3 6/8] memcg: Don't account root_mem_cgroup page
 statistics
Message-ID: <20130109125758.GA5095@dhcp22.suse.cz>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
 <1356456447-14740-1-git-send-email-handai.szj@taobao.com>
 <20130102122712.GE22160@dhcp22.suse.cz>
 <CAFj3OHWBtu9-7SdVJnMnUytjL9i3i2xEfoB=y_zA_5HXir9o0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFj3OHWBtu9-7SdVJnMnUytjL9i3i2xEfoB=y_zA_5HXir9o0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 05-01-13 18:52:12, Sha Zhengju wrote:
> On Wed, Jan 2, 2013 at 8:27 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Wed 26-12-12 01:27:27, Sha Zhengju wrote:
[...]
> >> @@ -5396,18 +5406,70 @@ static inline void mem_cgroup_lru_names_not_uptodate(void)
> >>       BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
> >>  }
> >>
> >> +long long root_memcg_local_stat(unsigned int i, long long val,
> >> +                                     long long nstat[])
> >
> > Function should be static
> > also
> > nstat parameter is ugly because this can be done by the caller
> > and also expecting that the caller already calculated val is not
> > nice (and undocumented). This approach is really hackish and error
> > prone. Why should we define a specific function rather than hooking into
> > mem_cgroup_read_stat and doing all the stuff there? I think that would
> > be much more maintainable.
> >
> 
> IMHO, hooking into mem_cgroup_read_stat may be also improper because
> of the for_each_mem_cgroup traversal. I prefer to make mem_cgroup_read_stat
> as the base func unit. But I'll repeal the function base on your opinion in next
> version.  Thanks for the advice!

Maybe my "do all the stuff there" was confusing. I didn't mean to
iterate through the hierarchy there. I just wanted to have
mem_cgroup_root is a special case and it uses global counters there.
-- 
Michal Hocko
SUSE Labs
