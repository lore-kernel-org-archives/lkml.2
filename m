Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab1E0H7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:59:18 -0400
Received: from smtp-tls2.univ-nantes.fr ([193.52.101.146]:38257 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1E0H7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:59:17 -0400
Message-ID: <4DDF593C.3060900@univ-nantes.fr>
Date: Fri, 27 May 2011 09:56:44 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Arun Sharma <asharma@fb.com>, David Miller <davem@davemloft.net>,
        Maximilian Engelhardt <maxi@daemonizer.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>,
        Denys Fedoryshchenko <denys@visp.net.lb>
Subject: Re: Kernel crash after using new Intel NIC (igb)
References: <201104250033.03401.maxi@daemonizer.de>	 <1303878240.2699.41.camel@edumazet-laptop>	 <1303878771.2699.44.camel@edumazet-laptop>	 <201104271352.00601.maxi@daemonizer.de>	 <20110512211033.GA3468@dev1756.snc6.facebook.com>	 <1305234953.2831.2.camel@edumazet-laptop>	 <20110524213327.GA3917@dev1756.snc6.facebook.com>	 <1306291469.3305.11.camel@edumazet-laptop>	 <20110525060609.GA32244@dev1756.snc6.facebook.com>	 <1306305331.3305.22.camel@edumazet-laptop>  <4DDEAA3C.7020502@fb.com>	 <1306439246.2543.10.camel@edumazet-laptop>  <4DDECA9B.8080206@fb.com>	 <1306447292.2543.32.camel@edumazet-laptop>  <4DDEEBC5.80804@fb.com> <1306466831.2543.58.camel@edumazet-laptop>
In-Reply-To: <1306466831.2543.58.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 27/05/2011 05:27, Eric Dumazet a écrit :
> Le jeudi 26 mai 2011 à 17:09 -0700, Arun Sharma a écrit :
>> On 5/26/11 3:01 PM, Eric Dumazet wrote:
>>
>>
>>>> Yeah - using the refcnt seems better than list_empty(), but I'm not sure
>>>> that your patch addresses the race above.
>>> It does.
>> True. I can't find any holes in this method and it resolves the "failure
>> to unlink from unused" case.
>>
>> Perhaps wrap the while(1) loop into its own primitive in atomic.h or use
>> an existing primitive?
>>
> Sure, here is a formal submission I cooked.
>
> Thanks
>
> [PATCH] inetpeer: fix race in unused_list manipulations

Thanks eric, didn't noticed this thread, nice to see you squashed this bug.
As you said in a previous message, slub_nomerge prevented us from 
crashing for 113 days now :)

But of course, THE REAL FIX is much preffered. Will try this patch with 
the next -stable update.

Thanks for your efforts,

-- 
Yann Dupont - Service IRTS, DSI Université de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

