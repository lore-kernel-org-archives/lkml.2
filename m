Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2ARP1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:27:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757891Ab2ARP1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:27:10 -0500
Date: Wed, 18 Jan 2012 16:27:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Sha <handai.szj@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: memcg: hierarchical soft limit reclaim
Message-ID: <20120118152708.GG31112@tiehlicka.suse.cz>
References: <1326207772-16762-3-git-send-email-hannes@cmpxchg.org>
 <CALWz4izwNBN_qcSsqg-qYw-Esc9vBL3=4cv3Wsg1jf6001_fWQ@mail.gmail.com>
 <20120112085904.GG24386@cmpxchg.org>
 <CALWz4iz3sQX+pCr19rE3_SwV+pRFhDJ7Lq-uJuYBq6u3mRU3AQ@mail.gmail.com>
 <20120113224424.GC1653@cmpxchg.org>
 <4F158418.2090509@gmail.com>
 <20120117145348.GA3144@cmpxchg.org>
 <CAFj3OHWY2Biw54gaGeH5fkxzgOhxn7NAibeYT_Jmga-_ypNSRg@mail.gmail.com>
 <20120118092509.GI24386@cmpxchg.org>
 <4F16AC27.1080906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F16AC27.1080906@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18-01-12 19:25:27, Sha wrote:
[...]
> Er... I'm even more confused: mem_cgroup_soft_limit_reclaim indeed
> choses the biggest soft-limit excessor first, but in the succeeding reclaim
> mem_cgroup_hierarchical_reclaim just selects a child cgroup  by css_id

mem_cgroup_soft_limit_reclaim picks up the hierarchy root (most
excessing one) and mem_cgroup_hierarchical_reclaim reclaims from that
subtree). It doesn't care who exceeds the soft limit under that
hierarchy it just tries to push the root under its limit as much as it
can. This is what Johannes tried to explain in the other email in the
thred.

> which has nothing to do with soft limit (see mem_cgroup_select_victim).
> IMHO, it's not a genuine hierarchical reclaim.

It is hierarchical because it iterates over hierarchy it is not and
never was recursively soft-hierarchical...

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
