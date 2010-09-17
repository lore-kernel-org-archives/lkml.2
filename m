Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab0IQLtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 07:49:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61131 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0IQLtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 07:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IYh9b1C3ta06mV3+rl+l0Nz5wQwMjIEQToI7B76sUgvNt+7JNjRo0VyZgl+fnVjgQ5
         j/b450EtJsWnXc5Kv8V7e+D1atJ2CdFqW0mmSPwgcAzWDumJG/0jmz7tJg3ESGO4lsSz
         ou8jRlgr56Bu9Js+Y+Zu77tNQlbejPABBDPbg=
MIME-Version: 1.0
In-Reply-To: <20100917063537.GA4534@balbir.in.ibm.com>
References: <20100916144618.852b7e9a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100916062159.GF22371@balbir.in.ibm.com>
	<20100916152204.6c457936.kamezawa.hiroyu@jp.fujitsu.com>
	<20100916161727.04a1f905.kamezawa.hiroyu@jp.fujitsu.com>
	<20100917063537.GA4534@balbir.in.ibm.com>
Date: Fri, 17 Sep 2010 20:49:09 +0900
Message-ID: <AANLkTikWqPf_SfYn7fzL7ROGqCY=ZZR5mUzr7sah+TOd@mail.gmail.com>
Subject: Re: [PATCH][-mm] memcg : memory cgroup cpu hotplug support update.
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/17 Balbir Singh <balbir@linux.vnet.ibm.com>:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-09-16 16:17:27]:
>
>> On Thu, 16 Sep 2010 15:22:04 +0900
>> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> > This naming is from mem_cgroup_walk_tree(). Now we have
>> >
>> >   mem_cgroup_walk_tree();
>> >   mem_cgroup_walk_all();
>> >
>> > Rename both ? But it should be in separated patch.
>> >
>>
>> Considering a bit ...but..
>>
>> #define for_each_mem_cgroup(mem) \
>>       for (mem = mem_cgroup_get_first(); \
>>            mem; \
>>            mem = mem_cgroup_get_next(mem);) \
>>
>> seems to need some helper functions. I'll consider about this clean up
>> but it requires some amount of patch because css_get()/css_put()/rcu...etc..
>> are problematic.
>>
>
> Why does this need to be a macro (I know we use this for lists and
> other places), assuming for now we don't use the iterator pattern, we
> can rename mem_cgroup_walk_all() to for_each_mem_cgroup().
>

When I see for_each in the kernel source, I expect iterator and macro.
When I see "walk" in the kernel source, I expect callback and visit function.

Thanks,
-Kame
