Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2E2NCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:02:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33841 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2E2NCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:02:45 -0400
Message-ID: <4FC4C943.2030007@gmail.com>
Date: Tue, 29 May 2012 21:04:03 +0800
From: Liu Zhiyou <liuzhiyou.cs@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111104 Red Hat/3.1.16-2.el6_1 Thunderbird/3.1.16
MIME-Version: 1.0
To: Xin Tong <xerox.time.tech@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: native_save_fl taking good amount of time in profile
References: <CALKntY1wDFxzZX6ONgeVuNjBxi=bPA-0vhWJ-_NMXR37GNmvBQ@mail.gmail.com>	<m2vcjjlwv0.fsf@firstfloor.org> <CALKntY1b_m1zAvMWFm7_rtpLn5S8tjZg2=fwiM5B-qWFwAKYLA@mail.gmail.com>
In-Reply-To: <CALKntY1b_m1zAvMWFm7_rtpLn5S8tjZg2=fwiM5B-qWFwAKYLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年05月26日 07:10, Xin Tong 写道:
> i do not know its callers from the profile. one thing i am suspicious
> of is that my kernel debug-info is wrong. by the way, what does the
> function do ?
>
> Thanks
>
> Xin
>
>
> On Fri, May 25, 2012 at 6:27 PM, Andi Kleen<andi@firstfloor.org>  wrote:
>> Xin Tong<xerox.time.tech@gmail.com>  writes:
>>
>>> I have collected a profile on the whole system. But the only thing
>>> that is really running is a mysql database server. I have noticed that
>>> there is a function in kernel that took 5% of the overall running
>>> time. what does native_save_fl do ? does it make sense that
>>> native_save_fl takes the most amount of time among all kernel
>>> functions ?
>> What are the callers (-g)? It does not make sense normally.
>> -Andi
Xin Tong,

Use perf record -g, then it will give you a call-graph.
$ man perf-record
-g, --call-graph
Do call-graph (stack chain/backtrace) recording.
$ man pref-report
-g [type,min[,limit],order], --call-graph
Display call chains using type, min percent threshold, optional print 
limit and order. type can be either:

· flat: single column, linear exposure of call chains.

· graph: use a graph tree, displaying absolute overhead rates.

· fractal: like graph, but displays relative rates. Each branch of the 
tree is considered as a new profiled object.

order can be either:
- callee: callee based call graph.
- caller: inverted caller based call graph.

Default: fractal,0.5,callee.

Regards,
LIU Zhiyou
