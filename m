Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2EaIcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:32:07 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43092 "EHLO mx2.parallels.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758029Ab2EaIcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:32:04 -0400
Message-ID: <4FC72BCD.7040403@parallels.com>
Date: Thu, 31 May 2012 12:29:01 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, <hannes@cmpxchg.org>,
        <mhocko@suse.cz>, <bsingharora@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com> <4FC70355.70805@jp.fujitsu.com> <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 10:17 AM, David Rientjes wrote:
>> >  Hmm....maybe need to mount cgroup in the container (again) and get an access
>> >  to cgroup
>> >  hierarchy and find the cgroup it belongs to......if it's allowed.
> An application should always know the cgroup that its attached to and be
> able to read its state using the command that I gave earlier.

I disagree. For simple applications, yes. For full containers, the 
cgroup in which it lives in is considered part of the external world.
It should not have any kind of access to it.

Also, tools need to work transparently.

That's the same case with /proc/stat, used for top. We can't expect 
people to recode top to work on containerized environments.
