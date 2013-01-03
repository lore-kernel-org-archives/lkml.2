Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3ACTlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 14:41:40 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:15691 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3ACTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 14:41:36 -0500
Message-ID: <50E5DEEF.2080009@hp.com>
Date: Thu, 03 Jan 2013 11:41:35 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: sedat.dilek@gmail.com, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] softirq: reduce latencies
References: <CA+icZUVEvzyrPsQG1QWLnHxhtaewaWTOVzBpTnLqjKuHMjjFHg@mail.gmail.com> <1357219919.21409.24519.camel@edumazet-glaptop>
In-Reply-To: <1357219919.21409.24519.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 05:31 AM, Eric Dumazet wrote:
> A common network load is to launch ~200 concurrent TCP_RR netperf
> sessions like the following
>
> netperf -H remote_host -t TCP_RR -l 1000

> And then you can launch some netperf asking P99_LATENCY results :
>
> netperf -H remote_host -t TCP_RR -- -k P99_LATENCY

In terms of netperf overhead, once you specify P99_LATENCY, you are 
already in for the pound of cost but only getting the penny of output 
(so to speak).  While it would clutter the output, one could go ahead 
and ask for the other latency stats and it won't "cost" anything more:

... -- -k 
RT_LATENCY,MIN_LATENCY,MAX_LATENCY,P50_LATENCY,P90_LATENCY,P99_LATENCY,MEAN_LATENCY,STDDEV_LATENCY

Additional information about how the omni output selectors work can be 
found at 
http://www.netperf.org/svn/netperf2/trunk/doc/netperf.html#Omni-Output-Selection

happy benchmarking,

rick jones

BTW - you will likely see some differences between RT_LATENCY, which is 
calculated from the average transactions per second, and MEAN_LATENCY, 
which is calculated from the histogram of individual latencies 
maintained when any of the _LATENCY outputs other than RT_LATENCY is 
requested.  Kudos to the folks at Google who did the extensions to the 
then-existing histogram code to enable it to be used for more reasonably 
accurate statistics.

