Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab0KCFZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 01:25:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab0KCFZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 01:25:55 -0400
Message-ID: <4CD0F22F.9000503@redhat.com>
Date: Wed, 03 Nov 2010 13:25:03 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc15 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net dst: fix percpu_counter list corruption and poison
 overwritten
References: <1288750265-17664-1-git-send-email-dfeng@redhat.com> <1288761773.2467.535.camel@edumazet-laptop>
In-Reply-To: <1288761773.2467.535.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 01:22 PM, Eric Dumazet wrote:
> Le mercredi 03 novembre 2010 à 10:11 +0800, Xiaotian Feng a écrit :
>> There're some percpu_counter list corruption and poison overwritten warnings
>> in recent kernel, which is resulted by fc66f95c.
>>
>> commit fc66f95c switches to use percpu_counter, in ip6_route_net_init, kernel
>> init the percpu_counter for dst entries, but, the percpu_counter is never destroyed
>> in ip6_route_net_exit. So if the related data is freed by kernel, the freed percpu_counter
>> is still on the list, then if we insert/remove other percpu_counter, list corruption
>> resulted. Also, if the insert/remove option modifies the ->prev,->next pointer of
>> the freed value, the poison overwritten is resulted then.
>>
>> With the following patch, the percpu_counter list corruption and poison overwritten
>> warnings disappeared.
>>
>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>> Cc: "David S. Miller"<davem@davemloft.net>
>> Cc: Alexey Kuznetsov<kuznet@ms2.inr.ac.ru>
>> Cc: "Pekka Savola (ipv6)"<pekkas@netcore.fi>
>> Cc: James Morris<jmorris@namei.org>
>> Cc: Hideaki YOSHIFUJI<yoshfuji@linux-ipv6.org>
>> Cc: Patrick McHardy<kaber@trash.net>
>> ---
>
> Good catch, thanks !
>
> Any reason you didnt Cc me (the author of the patch) ?
Sorry, I just used get_maintainer.pl to get the cc list...
>
> Acked-by: Eric Dumazet<eric.dumazet@gmail.com>
>
>
>
>

