Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0EJQDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:03:11 -0400
Received: from stinky.trash.net ([213.144.137.162]:49135 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0EJQDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:03:08 -0400
Message-ID: <4BE82E39.6080603@trash.net>
Date: Mon, 10 May 2010 18:03:05 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: mmotm 2010-04-28 - RCU whinges
References: <1272865137.2173.179.camel@edumazet-laptop>	 <1272865267.2173.180.camel@edumazet-laptop>	 <1272865436.2173.182.camel@edumazet-laptop>	 <20100502.225509.233880079.davem@davemloft.net>	 <4BE8290A.2080707@trash.net> <1273506968.2221.19.camel@edumazet-laptop>
In-Reply-To: <1273506968.2221.19.camel@edumazet-laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le lundi 10 mai 2010 à 17:40 +0200, Patrick McHardy a écrit :
>> David Miller wrote:
>>> From: Eric Dumazet <eric.dumazet@gmail.com>
>>> Date: Mon, 03 May 2010 07:43:56 +0200
>>>
>>>> Le lundi 03 mai 2010 à 07:41 +0200, Eric Dumazet a écrit :
>>>>
>>>>> Oops scratch that, I'll resend a correct version.
>>>>>
>>>>>
>>>> Sorry, patch _is_ fine, I had one brain collapse when re-reading it, I
>>>> thought a different mutex was in use in one of the functions.
>>> Ok, Patrick please review, thanks.
>> Actually we don't need the rcu_dereference() calls at all since
>> registration and unregistration are protected by the mutexes.
>>
>> I queued this patch in nf-next, the only reason why I haven't
>> submitted it yet is that I was unable to get git to cleanly export
>> only the proper set of patches meant for -next due to a few merges,
>> it insists on including 5 patches already merged upstream. If you
>> don't mind ignoring the first 5 patches in the series, I'll send a
>> pull request tonight.
>>
> 
> This will clash with upcoming RCU patches, where rcu protected pointer
> cannot be directly accessed without lockdep splats.
> 
> We will need one day or another a rcu_...(nf_conntrack_event_cb)

Thanks for the information, I didn't realize that when looking at
those patches. So I guess the correct fix once those patches are
merged would be to use rcu_assign_protected() and rcu_access_pointer().
