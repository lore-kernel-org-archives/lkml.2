Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2KTRpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:45:07 -0500
Received: from servizi.voixit.com ([78.46.247.94]:39696 "EHLO
	servizi.voixit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab2KTRpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:45:05 -0500
Message-ID: <50ABC19E.9030209@unimore.it>
Date: Tue, 20 Nov 2012 18:45:02 +0100
From: Paolo Valente <paolo.valente@unimore.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jhs@mojatatu.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
References: <20121112164833.GA12970@paolo-ThinkPad-W520> <20121119.184828.628106002307042971.davem@davemloft.net>
In-Reply-To: <20121119.184828.628106002307042971.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/11/2012 00:48, David Miller ha scritto:
> From: Paolo Valente <paolo.valente@unimore.it>
> Date: Mon, 12 Nov 2012 17:48:33 +0100
>
>> [This patch received positive feedback from Stephen Hemminger ("put in
>> net-next"), but no further feedback or decision. So I am (re)sending
>> an updated version of it. The only differences with respect to the
>> previous version are the support for TSO/GSO (taken from QFQ), and a
>> hopefully improved description.]
>
> Can you rearrange the logic so that the compiler doesn't emit this
> warning?
>
> In file included from net/sched/sch_qfq.c:18:0:
> net/sched/sch_qfq.c: In function ¡qfq_dequeue¢:
> include/net/sch_generic.h:480:15: warning: ¡skb¢ may be used uninitialized in this function [-Wmaybe-uninitialized]
> net/sched/sch_qfq.c:1007:18: note: ¡skb¢ was declared here
>
> You and I both know that SKB will be initialized at this point, but
> the compiler can't see it clearly enough.
>
Unfortunately I could not reproduce the warning (with
gcc-4.7 -Wmaybe-uninitialized). I am however about to send a new version 
with skb initialized to NULL. I hope that this fix properly addresses 
this issue.
> Thanks.
>


-- 
-----------------------------------------------------------
| Paolo Valente              |                            |
| Algogroup                  |                            |
| Dip. Ing. Informazione     | tel:   +39 059 2056318     |
| Via Vignolese 905/b        | fax:   +39 059 2056129     |
| 41125 Modena - Italy       |                            |
|     home:  http://algo.ing.unimo.it/people/paolo/       |
-----------------------------------------------------------
