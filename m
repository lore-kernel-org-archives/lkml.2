Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107Ab1LOQS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:18:59 -0500
Received: from mx2.parallels.com ([64.131.90.16]:59166 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758993Ab1LOQS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:18:58 -0500
Message-ID: <4EEA1DCB.7040402@parallels.com>
Date: Thu, 15 Dec 2011 20:18:19 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <cgroups@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/2] Explicitly call tcp creation and init from memcontrol.c
References: <1323941672-14324-1-git-send-email-glommer@parallels.com> <1323941672-14324-3-git-send-email-glommer@parallels.com> <20111216011316.8d58bc8f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111216011316.8d58bc8f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 08:13 PM, KAMEZAWA Hiroyuki wrote:
> On Thu, 15 Dec 2011 13:34:32 +0400
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> Walking the proto_list holds a read_lock, which prevents us from doing
>> allocations. Splitting the tcp create function into create + init is
>> good, but it is not enough since create_files will do allocations as well
>> (dentry ones, mostly).
>>
>> Since this does not involve any protocol state, I propose we call the tcp
>> functions explicitly from memcontrol.c
>>
>> With this, we lose by now the ability of doing cgroup memcontrol for
>> protocols that are loaded as modules. But at least the ones I have in mind
>> won't really need it (tcp_ipv6 being the only one, but it uses the same data
>> structures as tcp_ipv4). So I believe this to be the simpler solution to this
>> problem.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>> CC: David S. Miller<davem@davemloft.net>
>> CC: Eric Dumazet<eric.dumazet@gmail.com>
>> CC: Stephen Rothwell<sfr@canb.auug.org.au>
>
> Could you remake the patch onto the 'latest' linux-next ?
> As Dave mentioned, some bandaids are already applied and this patch hunks.

Sure thing.
