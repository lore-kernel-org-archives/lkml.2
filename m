Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2AUOSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 09:18:21 -0500
Received: from mx2.parallels.com ([64.131.90.16]:43253 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab2AUOSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 09:18:18 -0500
Message-ID: <4F1AC8F6.1060703@parallels.com>
Date: Sat, 21 Jan 2012 18:17:26 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <netdev@vger.kernel.org>, <eric.dumazet@gmail.com>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/3] net: fix socket memcg build with !CONFIG_NET
References: <1327071436-20763-1-git-send-email-glommer@parallels.com> <1327071436-20763-2-git-send-email-glommer@parallels.com> <20120120.141446.136970067758991080.davem@davemloft.net>
In-Reply-To: <20120120.141446.136970067758991080.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 11:14 PM, David Miller wrote:
> From: Glauber Costa<glommer@parallels.com>
> Date: Fri, 20 Jan 2012 18:57:14 +0400
>
>> There is still a build bug with the sock memcg code, that triggers
>> with !CONFIG_NET, that survived my series of randconfig builds.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> Reported-by: Randy Dunlap<rdunlap@xenotime.net>
>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>
> Why are you undoing the static branch optimization?  That was a one of
> the things that made me agree to even putting this code in.
>
> Find a way to fix this without removing the static branch.
>
Dave,

I am not removing the static branch. This is just a macro, that expands 
to the static branch when the options are in place, and to 0 if they are 
not.

if (0) { } is certainly be removed to the compiler, so the code is out
anyway.
