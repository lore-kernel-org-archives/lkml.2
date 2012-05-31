Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab2EaAor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:44:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59516 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2EaAop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:44:45 -0400
Date: Wed, 30 May 2012 17:44:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
In-Reply-To: <4FC6BC3E.5010807@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com>
 <4FC6BC3E.5010807@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Kamezawa Hiroyuki wrote:

> My test with sysfs node's meminfo seems to work...
> 
> [root@rx100-1 qqm]# mount --bind /sys/devices/system/node/node0/meminfo
> /proc/meminfo
> [root@rx100-1 qqm]# cat /proc/meminfo
> 
> Node 0 MemTotal:        8379636 kB

This doesn't seem like a good idea unless the application supports the 
"Node 0" prefix in /proc/meminfo.

If any application really cares about the amount of memory available to 
it, it should be taught to be memcg aware.  Then do something like

cat $(grep memory /proc/mounts | cut -d " " -f 2)/$(grep memory /proc/self/cgroup | cut -d : -f 3)/memory.limit_in_bytes

but since that value can change all the time then it doesn't seem helpful 
unless we have a userspace notifier.
