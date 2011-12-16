Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1LPJyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 04:54:08 -0500
Received: from mx2.parallels.com ([64.131.90.16]:38580 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1LPJx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 04:53:59 -0500
Message-ID: <4EEB1508.3080405@parallels.com>
Date: Fri, 16 Dec 2011 13:53:12 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <netdev@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v2] net: fix sleeping while atomic problem in sock mem_cgroup.
References: <1324026582-5214-1-git-send-email-glommer@parallels.com> <1324027869.2273.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1324027869.2273.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [85.26.155.19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 01:31 PM, Eric Dumazet wrote:
> Le vendredi 16 décembre 2011 à 13:09 +0400, Glauber Costa a écrit :
>> Since we can't scan the proto_list to initialize sock cgroups, as it
>> holds a rwlock, and we also want to keep the code generic enough to
>> avoid calling the initialization functions of protocols directly,
>> I propose we keep the interested parties in a separate list. This list
>> is protected by a mutex so we can sleep and do the necessary allocations.
>>
>> Also fixes a reference problem found by Randy Dunlap's randconfig.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>> CC: David S. Miller<davem@davemloft.net>
>> CC: Eric Dumazet<eric.dumazet@gmail.com>
>> CC: Stephen Rothwell<sfr@canb.auug.org.au>
>> CC: Randy Dunlap<rdunlap@xenotime.net>
>> ---
>
> Sorry to come late, but why dont we convert proto_list_lock to a mutex ?

I didn't suggest this, as I imagined there could be some performance 
implications to be drawn from it that may not be obvious to me.

But if it is okay with you net guys, it is certainly okay with me as well.
