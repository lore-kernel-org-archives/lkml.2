Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1IXR2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 13:28:22 -0400
Received: from mx2.parallels.com ([64.131.90.16]:34488 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab1IXR2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 13:28:21 -0400
Message-ID: <4E7E1306.9060200@parallels.com>
Date: Sat, 24 Sep 2011 14:27:34 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>
Subject: Re: [PATCH v3 6/7] tcp buffer limitation: per-cgroup limit
References: <1316393805-3005-1-git-send-email-glommer@parallels.com> <1316393805-3005-7-git-send-email-glommer@parallels.com> <m24o01khcp.fsf@firstfloor.org>
In-Reply-To: <m24o01khcp.fsf@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.134.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2011 01:58 PM, Andi Kleen wrote:
> Glauber Costa<glommer@parallels.com>  writes:
>
>> This patch uses the "tcp_max_mem" field of the kmem_cgroup to
>> effectively control the amount of kernel memory pinned by a cgroup.
>>
>> We have to make sure that none of the memory pressure thresholds
>> specified in the namespace are bigger than the current cgroup.
>
> I noticed that some other OS known by bash seem to have a rlimit per
> process for this. Would that make sense too? Not sure how difficult
> your infrastructure would be to extend to that.
>
> -Andi
>
Well, not that hard, I believe.

and given the benchmarks I've run in this iteration, I think it wouldn't
be that much of a performance impact either. We just need to account it 
to a task whenever we account it for a control group. Now that the 
functions where accounting are done are abstracted away, it is even 
quite few places to touch.

