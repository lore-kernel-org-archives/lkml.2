Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab0IHFdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 01:33:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35649 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab0IHFda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 01:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cgLcxdZ0iJe9lJn+AS/eEOzFVJ3YH2waTXAazYuKBw9YtxmYSTGh8WRbHsEbg+qD5M
         CHfWiwpKPMKcSJgR5qA8o4XPPU3Ol5w1pKm1gnj1AMrVHMJQTieapjkisrO4vGPYld1f
         PS4qfwaRIX+4Gr1hoeMSVz1vokywYqhgWZ9mQ=
MIME-Version: 1.0
In-Reply-To: <1283923185.2634.772.camel@edumazet-laptop>
References: <AANLkTikp0m8cQYfEBHP_E8XpGZqdMj6Cr4M=aWCnei=X@mail.gmail.com>
	<1283923185.2634.772.camel@edumazet-laptop>
Date: Wed, 8 Sep 2010 13:33:28 +0800
Message-ID: <AANLkTim+=vj+k3=1hzT3=J4ssOopp5Eq=g+DHis=pZFN@mail.gmail.com>
Subject: Re: [PATCH] netlink: Fix kfree NULL pointer
From: jovi zhang <bookjovi@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 1:19 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mercredi 08 septembre 2010 à 13:13 +0800, jovi zhang a écrit :
>> It will kfree NULL pointer if listeners is NULL. fix it.
>>
>> Signed-off-by: bookjovi@gmail.com
>> net/netlink/af_netlink.c |    5 +++--
>> 1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
>> index 980fe4a..1c7bf48 100644
>> --- a/net/netlink/af_netlink.c
>> +++ b/net/netlink/af_netlink.c
>> @@ -1532,8 +1532,10 @@ netlink_kernel_create(struct net *net, int
>> unit, unsigned int groups,
>>        if (input)
>>                nlk_sk(sk)->netlink_rcv = input;
>>
>> -       if (netlink_insert(sk, net, 0))
>> +       if (netlink_insert(sk, net, 0)) {
>> +               kfree(listeners);
>>                goto out_sock_release;
>> +       }
>>
>>        nlk = nlk_sk(sk);
>>        nlk->flags |= NETLINK_KERNEL_SOCKET;
>> @@ -1553,7 +1555,6 @@ netlink_kernel_create(struct net *net, int unit,
>> unsigned int groups,
>>        return sk;
>>
>> out_sock_release:
>> -       kfree(listeners);
>>        netlink_kernel_release(sk);
>>        return NULL;
>
>
> This patch is not needed
>
> kfree(NULL) is legal
>
>
>
>

YES, maybe kfree(NULL) is legal, but I cannot see there have any need
to invoke kfree(NULL) in this function.
 Also I check kfree usage in other code, I havn't find any kfree(NULL) usage.
