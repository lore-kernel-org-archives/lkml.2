Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1FGOoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:44:32 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:54281 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764Ab1FGOoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:44:30 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-a8-4dee3909b342
Message-ID: <4DEE3944.5020005@mit.edu>
Date: Tue, 07 Jun 2011 10:44:20 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	 <1307373819.3098.40.camel@edumazet-laptop>	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>	 <1307377349.3098.65.camel@edumazet-laptop>	 <1307377782.2322.183.camel@twins>	 <1307378564.3098.67.camel@edumazet-laptop>	 <4DED1421.5000300@linux.intel.com> <1307383898.3098.90.camel@edumazet-laptop> <4DED976C.90009@linux.intel.com>
In-Reply-To: <4DED976C.90009@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsUixCmqrMtp+c7X4PR+bYttp7czW9w5rGGx
	7/1ZNounn/pYLNqO/WOxuLxrDpvFlkvNrBbHew8wWZybJmWxedNUZou2+X2sDtwet9r+MHvs
	nHWX3WPBplKPzSu0PE48ucTm8e7cOXaPeScDPZ5+PcTs8XmTXABnFJdNSmpOZllqkb5dAlfG
	qr3f2AvmcFf8XvmCtYHxM0cXIyeHhICJxLRZK9ghbDGJC/fWs3UxcnEICexjlNjwayYLhLOe
	UWLFs89gVUIC55kkrjfrgNi8AmoSy1b+YAKxWQRUJW7tmswGYrMJqEh0LH0AFhcVqJSY9HMH
	K0S9oMTJmU9YQGwRAQ2J5ilzGEEWMAvsZpZ4/+QuWIOwgI1E57duRojNc5klFnS/YwZJcAro
	Shy9tRRsErOAmUTX1i5GCFteonnrbOYJjIKzkCyZhaRsFpKyBYzMqxhlU3KrdHMTM3OKU5N1
	i5MT8/JSi3SN9HIzS/RSU0o3MYIjS5J3B+O7g0qHGAU4GJV4eE2/v/EVYk0sK67MPcQoycGk
	JMrLbPbOV4gvKT+lMiOxOCO+qDQntfgQowQHs5II74zrb32FeFMSK6tSi/JhUtIcLErivDMl
	1X2FBNITS1KzU1MLUotgsjIcHEoSvNoWQEMFi1LTUyvSMnNKENJMHJwgw3mAhr80B6rhLS5I
	zC3OTIfIn2JUlBLnNQNpFgBJZJTmwfXCEt8rRnGgV4R5J4NU8QCTJlz3K6DBTECDT58Fubq4
	JBEhJdXAeNGuxvmMW9mZi50yOQy7NK9+ebrg2eE081wbjqW3Ty29nJTTY3yn8eis3wnVvOWZ
	Xf5Jcz72HPDJjVUOfNP2zkKmTqan67rEpyLOlXeeLshw3993cMO6SNdZyzcobBW6wrWTUzXu
	PuMr98y+OQJs87lmTq75+2nJjeki8k4fvAwY3DLjAq78UmIpzkg01GIuKk4EACDlykpXAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2011 11:13 PM, Darren Hart wrote:
>
>
> On 06/06/2011 11:11 AM, Eric Dumazet wrote:
>> Le lundi 06 juin 2011 à 10:53 -0700, Darren Hart a écrit :
>>>
>>
>>> If I understand the problem correctly, RO private mapping really doesn't
>>> make any sense and we should probably explicitly not support it, while
>>> special casing the RO shared mapping in support of David's scenario.
>>>
>>
>> We supported them in 2.6.18 kernels, apparently. This might sounds
>> stupid but who knows ?
>
>
> I guess this is actually the key point we need to agree on to provide a
> solution. This particular case "worked" in 2.6.18 kernels, but that
> doesn't necessarily mean it was supported, or even intentional.
>
> It sounds to me that we agree that we should support RO shared mappings.
> The question remains about whether we should introduce deliberate
> support of RO private mappings, and if so, if the forced COW approach is
> appropriate or not.
>

I disagree.

FUTEX_WAIT has side-effects.  Specifically, it eats one wakeup sent by 
FUTEX_WAKE.  So if something uses futexes on a file mapping, then a 
process with only read access could (if the semantics were changed) DoS 
the other processes by spawning a bunch of threads and FUTEX_WAITing 
from each of them.

If there were a FUTEX_WAIT_NOCONSUME that did not consume a wakeup and 
worked on RO mappings, I would drop my objection.

--Andy
