Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492Ab2J2VIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:08:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60579 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2J2VII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:08:08 -0400
Date: Mon, 29 Oct 2012 14:08:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [V5 PATCH 08/26] memcontrol: use N_MEMORY instead
 N_HIGH_MEMORY
In-Reply-To: <20121029205806.GB21640@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.00.1210291405100.18552@chino.kir.corp.google.com>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com> <1351524078-20363-7-git-send-email-laijs@cn.fujitsu.com> <20121029162212.GE20757@dhcp22.suse.cz> <alpine.DEB.2.00.1210291340100.18552@chino.kir.corp.google.com>
 <20121029205806.GB21640@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, Michal Hocko wrote:

> > > > N_HIGH_MEMORY stands for the nodes that has normal or high memory.
> > > > N_MEMORY stands for the nodes that has any memory.
> > > 
> > > What is the difference of those two?
> > > 
> > 
> > Patch 5 in the series 
> 
> Strange, I do not see that one at the mailing list.
> 

http://marc.info/?l=linux-kernel&m=135152595827692

> > introduces it to be equal to N_HIGH_MEMORY, so 
> 
> So this is just a rename? If yes it would be much esier if it was
> mentioned in the patch description.
> 

It's not even a rename even though it should be, it's adding yet another 
node_states that is equal to N_HIGH_MEMORY since that state already 
includes all memory.  It's just a matter of taste but I think we should be 
renaming it instead of aliasing it (unless you actually want to make 
N_HIGH_MEMORY only include nodes with highmem, but nothing depends on 
that).
