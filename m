Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab2ATLKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:10:13 -0500
Received: from mx2.parallels.com ([64.131.90.16]:49578 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab2ATLKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:10:09 -0500
Message-ID: <4F194B5D.6080701@parallels.com>
Date: Fri, 20 Jan 2012 15:09:17 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: linux-next: Tree for Jan 19 (mm/memcontrol.c)
References: <20120119125932.a4c67005cf6a0938558e8b36@canb.auug.org.au> <4F189A97.5080007@xenotime.net> <20120120090037.e32a119f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120120090037.e32a119f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 04:00 AM, KAMEZAWA Hiroyuki wrote:
> On Thu, 19 Jan 2012 14:35:03 -0800
> Randy Dunlap<rdunlap@xenotime.net>  wrote:
>
>> On 01/18/2012 05:59 PM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20120118:
>>
>>
>> on i386:
>>
>> mm/built-in.o:(__jump_table+0x8): undefined reference to `memcg_socket_limit_enabled'
>> mm/built-in.o:(__jump_table+0x14): undefined reference to `memcg_socket_limit_enabled'
>>
>>
>> Full randconfig file is attached.
>>
>
> Thank you. Forwarding this to Costa.
>
> Thanks,
> -Kame
>
Oh dear lord... So what happened here, is that I moved this code out of 
CONFIG_INET to fix another problem, and forgot that it needed to be 
wrapped under CONFIG_NET instead.

It is not an excuse, but I did compiled it over at least 6 random 
configs, and thought it was okay. I guess so many things select 
CONFIG_NET that it ends up being hard to generate a config without it.

I think the fix for this needs to go through dave's tree, since it is 
where the original fix went through.

I will send a fix shortly.
