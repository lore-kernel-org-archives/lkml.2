Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab1IRTnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 15:43:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51606 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636Ab1IRTnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 15:43:19 -0400
Message-ID: <4E7649AA.40305@parallels.com>
Date: Sun, 18 Sep 2011 16:42:34 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, <linux-kernel@vger.kernel.org>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <ebiederm@xmission.com>,
        <davem@davemloft.net>, <gthelen@google.com>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH v2 4/7] per-cgroup tcp buffers control
References: <1316051175-17780-1-git-send-email-glommer@parallels.com> <1316051175-17780-5-git-send-email-glommer@parallels.com> <20110917181132.GC1658@shutemov.name> <20110917183358.GB2783@moon> <20110918185806.GA28057@shutemov.name>
In-Reply-To: <20110918185806.GA28057@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2011 03:58 PM, Kirill A. Shutemov wrote:
> On Sat, Sep 17, 2011 at 10:33:58PM +0400, Cyrill Gorcunov wrote:
>> On Sat, Sep 17, 2011 at 09:11:32PM +0300, Kirill A. Shutemov wrote:
>>> On Wed, Sep 14, 2011 at 10:46:12PM -0300, Glauber Costa wrote:
>>>> +int tcp_init_cgroup_fill(struct proto *prot, struct cgroup *cgrp,
>>>> +			 struct cgroup_subsys *ss)
>>>> +{
>>>> +	prot->enter_memory_pressure	= tcp_enter_memory_pressure;
>>>> +	prot->memory_allocated		= memory_allocated_tcp;
>>>> +	prot->prot_mem			= tcp_sysctl_mem;
>>>> +	prot->sockets_allocated		= sockets_allocated_tcp;
>>>> +	prot->memory_pressure		= memory_pressure_tcp;
>>>
>>> No fancy formatting, please.
>>>
>>
>> What's wrong with having fancy formatting? It's indeed easier to read
>> when members are assigned this way. It's always up to maintainer to
>> choose what he prefers, but I see nothing wrong in such style (if only it
>> doesn't break the style of the whole file).
>
> You have to remove this indenting if you'll reorganize code (e.g. move
> part under if(...)).
> IMO, it reduces code maintainability.
>
As I said, I don't care, so I'll change. But I have to say I disagree 
with your statement.

It is a pack of assignments, so if you reorganize this code, two things 
can happen:
1) It is not moved to a new ident level -> It keeps being a pack of 
assignments, and you don't really need to change it.
2) It is moved to a new ident level -> You have to touch it anyway...

