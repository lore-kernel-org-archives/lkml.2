Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0GNLl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:41:27 -0400
Received: from stinky.trash.net ([213.144.137.162]:51235 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0GNLl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:41:26 -0400
Message-ID: <4C3DA268.20008@trash.net>
Date: Wed, 14 Jul 2010 13:41:28 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Felipe W Damasio <felipewd@gmail.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>	 <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>	 <1278626921.2435.73.camel@edumazet-laptop>	 <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com> <1278695580.2696.55.camel@edumazet-laptop>
In-Reply-To: <1278695580.2696.55.camel@edumazet-laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.07.2010 19:13, Eric Dumazet wrote:
> Le vendredi 09 juillet 2010 à 12:03 -0300, Felipe W Damasio a écrit :
>> Hi,
>>
>> 2010/7/8 Eric Dumazet <eric.dumazet@gmail.com>:
>>> Please try to reproduce a new report.
>>>
>>> It looks like a memory corruption, and it would be good to see if a
>>> common pattern is occurring.
>>
>> I'm trying..the thing is the freeze occured on the machine that sits
>> on a 200Mbps ISP in bridge-mode. Since the machine frooze, and the
>> whole ISP went down for a few minutes, I'm not allowed to run any
>> tests on it.
>>
>> I've setup the same scenario on a lab, but since last night been
>> unable to reproduce the bug. Maybe there's a clue on the this crash
>> below that can help me write some program to trigger the problem?
>>
> 
> Reviewing tproxy stuff I spotted a problem in nf_tproxy_assign_sock()
> but I could not see how it could explain your crash.
> 
> We can read uninitialized memory and trigger a fault in
> nf_tproxy_assign_sock(), not later in tcp_recvmsg()...
> 
> David, Patrick, what do you think ?
> 
> Thanks
> 
> [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
> 
> transparent field of a socket is either inet_twsk(sk)->tw_transparent
> for timewait sockets, or inet_sk(sk)->transparent for other sockets
> (TCP/UDP).

I don't see anything preventing use of timewait sockets, so the
patch looks correct to me.

Applied to nf-2.6.git, thanks Eric.
