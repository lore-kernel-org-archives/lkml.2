Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab2EaAz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:55:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55775 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2EaAzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:55:55 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FC6C111.2060108@jp.fujitsu.com>
Date: Thu, 31 May 2012 09:53:37 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/31 9:44), David Rientjes wrote:
> On Thu, 31 May 2012, Kamezawa Hiroyuki wrote:
>
>> My test with sysfs node's meminfo seems to work...
>>
>> [root@rx100-1 qqm]# mount --bind /sys/devices/system/node/node0/meminfo
>> /proc/meminfo
>> [root@rx100-1 qqm]# cat /proc/meminfo
>>
>> Node 0 MemTotal:        8379636 kB
>
> This doesn't seem like a good idea unless the application supports the
> "Node 0" prefix in /proc/meminfo.
>
Of course, /cgroup/memory/..../memory.meminfo , a new file, will use the same
format of /proc/meminfo. Above is just an example of bind-mount.

> If any application really cares about the amount of memory available to
> it, it should be taught to be memcg aware.  Then do something like
>

Considering the container as a kind of virtualization, Some kind of
transparent way is required.

Thanks,
-Kame


