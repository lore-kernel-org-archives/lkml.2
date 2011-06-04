Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1FDMFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 08:05:21 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35104 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab1FDMFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 08:05:19 -0400
Message-ID: <4DEA1F5F.4070707@ahsoftware.de>
Date: Sat, 04 Jun 2011 14:04:47 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
Subject: Re: bridge/netfilter: regression in 2.6.39.1
References: <4DE93422.3070000@ahsoftware.de>	 <1307129642.2600.2.camel@edumazet-laptop>  <4DE93B31.8040700@ahsoftware.de> <1307130914.2600.12.camel@edumazet-laptop>
In-Reply-To: <1307130914.2600.12.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.06.2011 21:55, schrieb Eric Dumazet:
> Le vendredi 03 juin 2011 à 21:51 +0200, Alexander Holler a écrit :
>> Hello,
>>
>> Am 03.06.2011 21:34, schrieb Eric Dumazet:
>>>>
>>>> Commit 42923465fb8d025a2b5153f2e7ab1e6e1058bf00 does here what it
>>>> should prevent, it introduces NULL a dereference.
>>>>
>>>
>>> I cant find this commit in known trees. Could you give the real commit
>>> id and its title ?
>>
>> Sorry, I haven't seen that question at first. This is the real commit id
>> as found in the stable tree for 2.6.39. The title of that commit is
>> "bridge: initialize fake_rtable metrics"
>
> OK, its commit id is 33eb9873a283a2076f2b5628813d5365ca420ea9
>
> Please always use linux-2.6 tree commits, this saves a lot of time.

Sorry to have wasted your time with posting a full breakdown of the bug 
and a possible solution. I didn't know that stable trees are unknown to 
kernel developers and I did'nt know that the "upstream commit id" in 
comments of commits in the stable tree are referencing to commit ids in 
Linus tree.

Anyway, I've used the broken way of not using git send-email because I'm 
unsure if the solution I've offered is the best one. I'm lacking the 
knowledge about what cow_metrics() does, what it is used for, and what, 
if any, pre- or post-requisites are needed to use dst_cow_metrics_generic().

I can only say that my solution seems to work here, the machine comes up 
without an oops and I didn't have seen any other problems while using 
the bridge (which surely doesn't say anything, e.g. I'm not sure if my 
use of dst_cow_metrics_generic() may introduce a mem leak or similiar, 
it doesn't look so, but who knows).

Regards,

Alexander

