Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2EaJBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:01:50 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56339 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab2EaJBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:01:48 -0400
Message-ID: <4FC732F5.6080706@parallels.com>
Date: Thu, 31 May 2012 12:59:33 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Gao feng <gaofeng@cn.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, <hannes@cmpxchg.org>,
        <mhocko@suse.cz>, <bsingharora@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com> <4FC70355.70805@jp.fujitsu.com> <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com> <4FC70E5E.1010003@gmail.com> <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com> <4FC711A5.4090003@gmail.com> <alpine.DEB.2.00.1205302351510.25774@chino.kir.corp.google.com> <CAHGf_=qVDVT6VW2j9gE3bQKwizW24iivrDryiCKoxVu4m_fWKw@mail.gmail.com> <alpine.DEB.2.00.1205310028420.8864@chino.kir.corp.google.com> <4FC720EE.3010307@gmail.com> <4FC724B1.70508@cn.fujitsu.com> <4FC72CA4.6080708@parallels.com> <4FC73110.6010107@jp.fujitsu.com>
In-Reply-To: <4FC73110.6010107@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 12:51 PM, Kamezawa Hiroyuki wrote:
>> One think to keep in mind: A file in memcg does not need to follow the
>> same format
>> of /proc/meminfo so we can bind mount. We should be able to
>> reconstruct that in
>>  userspace based on information available from the kernel. You can
>> even collect that
>> from multiple locations, and *then* you bind mount.
>
> I'm sorry I couldn't fully understand. Could you explain more ?
> Do you mean
>   - bind mount memory cgroup directory into the container for exporting
> information
>   - Some user-space apps, FUSE-procfs or some, can provide enough
> information
>

Implementation details aside, the idea is to have something like FUSE to 
hook the read(), and then construct the information it needs to present 
in the proper format.

Alternatively, for files that doesn't change a lot, you can create a 
file /container-storage-area/my_copy_of_meminfo at container creation, 
and bind mount *that* file.

There is no reason to bind mount a kernel-provided file directly.

