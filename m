Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1I1ME4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:04:56 -0400
Received: from mx2.parallels.com ([64.131.90.16]:59669 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab1I1MEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:04:54 -0400
Message-ID: <4E830D1B.1070503@parallels.com>
Date: Wed, 28 Sep 2011 09:03:39 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <ebiederm@xmission.com>, <davem@davemloft.net>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>
Subject: Re: [PATCH v3 1/7] Basic kernel memory functionality for the Memory
 Controller
References: <1316393805-3005-1-git-send-email-glommer@parallels.com> <1316393805-3005-2-git-send-email-glommer@parallels.com> <20110926193451.b419f630.kamezawa.hiroyu@jp.fujitsu.com> <4E81084F.9010208@parallels.com> <20110928095826.eb8ebc8c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110928095826.eb8ebc8c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.46.173.177]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 09:58 PM, KAMEZAWA Hiroyuki wrote:
> On Mon, 26 Sep 2011 20:18:39 -0300
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> On 09/26/2011 07:34 AM, KAMEZAWA Hiroyuki wrote:
>>> On Sun, 18 Sep 2011 21:56:39 -0300
>>> Glauber Costa<glommer@parallels.com>   wrote:
> "If parent sets use_hierarchy==1, children must have the same kmem_independent value
>>> with parant's one."
>>>
>>> How do you think ? I think a hierarchy must have the same config.
>> BTW, Kame:
>>
>> Look again (I forgot myself when I first replied to you)
>> Only in the root cgroup those files get registered.
>> So shouldn't be a problem, because children won't even
>> be able to see them.
>>
>> Do you agree with this ?
>>
>
> agreed.
>

Actually it is the other way around, following previous suggestions...

The root cgroup does *not* get those files registered, since we don't 
intend to do any kernel memory limitation for it. The others get it.
Given that, I will proceed writing some code to respect parent cgroup's
hierarchy.
