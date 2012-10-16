Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab2JPSjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:39:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41995 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2JPSjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:39:35 -0400
Date: Tue, 16 Oct 2012 11:39:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Sha Zhengju <handai.szj@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
In-Reply-To: <20121016133439.GI13991@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.00.1210161136470.2910@chino.kir.corp.google.com>
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com> <20121016133439.GI13991@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Michal Hocko wrote:

> The primary motivation for oom_kill_allocating_task AFAIU was to reduce
> search over huge tasklists and reduce task_lock holding times. I am not
> sure whether the original concern is still valid since 6b0c81b (mm,
> oom: reduce dependency on tasklist_lock) as the tasklist_lock usage has
> been reduced conciderably in favor of RCU read locks is taken but maybe
> even that can be too disruptive?
> David?
> 

When the oom killer became serialized, the folks from SGI requested this 
tunable to be able to avoid the expensive tasklist scan on their systems 
and to be able to avoid killing threads that aren't allocating memory at 
all in a steady state.  It wasn't necessarily about tasklist_lock holding 
time but rather the expensive iteration over such a large number of 
processes.

> Moreover memcg oom killer doesn't iterate over tasklist (it uses
> cgroup_iter*) so this shouldn't cause the performance problem like
> for the global case.

Depends on how many threads are attached to a memcg.
