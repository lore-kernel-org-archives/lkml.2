Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab0LBDKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 22:10:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab0LBDKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 22:10:02 -0500
Message-ID: <4CF70EFA.2070504@redhat.com>
Date: Thu, 02 Dec 2010 11:14:02 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        Thomas Graf <tgraf@infradead.org>
Subject: Re: [Patch] net: kill an RCU warning in inet_fill_link_af()
References: <1291202063-6239-1-git-send-email-amwang@redhat.com> <1291219386.2856.924.camel@edumazet-laptop>
In-Reply-To: <1291219386.2856.924.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/10 00:03, Eric Dumazet wrote:
> Le mercredi 01 décembre 2010 à 19:14 +0800, Amerigo Wang a écrit :
>> From: WANG Cong<amwang@redhat.com>
>>
>> The latest net-next-2.6 triggers an RCU warning during boot,
>> lockdep complains that in inet_fill_link_af() we call rcu_dereference_check()
>> without rcu_read_lock() protection.
>>
>> This patch fixes it by replacing __in_dev_get_rcu() with in_dev_get().
>
> Here is a better version, thanks a lot for your report and initial
> patch.
>
>
> [PATCH net-next-2.6] net: kill an RCU warning in inet_fill_link_af()
>
> commits 9f0f7272 (ipv4: AF_INET link address family) and cf7afbfeb8c
> (rtnl: make link af-specific updates atomic) used incorrect
> __in_dev_get_rcu() in RTNL protected contexts, triggering PROVE_RCU
> warnings.
>
> Switch to __in_dev_get_rtnl(), wich is more appropriate, since we hold
> RTNL.
>
> Based on a report and initial patch from Amerigo Wang.
>

Alright, thanks for fixing it.

Reviewed-by: WANG Cong <amwang@redhat.com>

