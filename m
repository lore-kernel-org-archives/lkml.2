Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1KXQIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:08:15 -0500
Received: from mx2.parallels.com ([64.131.90.16]:33724 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab1KXQIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:08:14 -0500
Message-ID: <4ECE6BC4.7090600@parallels.com>
Date: Thu, 24 Nov 2011 14:07:32 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Paul Turner <pjt@google.com>,
        <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, <fweisbec@gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>  <1320182360-20043-15-git-send-email-glommer@parallels.com>  <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com>  <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>  <CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>  <20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>  <4EC47632.2000904@parallels.com>  <CAKTCnznzpqUbMJEMwaewwjvMW1fG0J3=a8JxqKiHKNuffO7azg@mail.gmail.com>  <4EC52F32.2040708@parallels.com>  <20111121105957.9c85db16.kamezawa.hiroyu@jp.fujitsu.com> <1322141073.2921.51.camel@twins>
In-Reply-To: <1322141073.2921.51.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 11:24 AM, Peter Zijlstra wrote:
> On Mon, 2011-11-21 at 10:59 +0900, KAMEZAWA Hiroyuki wrote:
>> Could you share your analysis why cpuacct cgroup is slow ?
>
> It adds accounting to all scheduler hot paths, accounting that is mostly
> duplicate of accounting already done. It also does another cgroup
> hierarchy walk, separate from existing controllers, hitting all cold
> cachelines again.
>
> IOW, it sucks chunks and I should never have allowed it to be merged.

OTOH, if the use case for it includes separating processes for the cpu 
and cpuacct cgroups in an independent manner - which apparently it does, 
I've just learned, there isn't much we can do except try to make it cheaper.

The direction I am going right now wrt this is to clean this up and 
reduce the impact of it when the root cgroup is the only one active. All 
other users are using the functionality, so let them pay...
