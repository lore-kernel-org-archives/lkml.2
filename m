Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1LSHNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 02:13:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab1LSHNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 02:13:46 -0500
Message-ID: <4EEEE5FF.9050502@redhat.com>
Date: Mon, 19 Dec 2011 15:21:35 +0800
From: Amos Kong <akong@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rhod <rhod@redhat.com>, Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>  <1322867384.11728.20.camel@pasglop> <87hb1iqls3.fsf@rustcorp.com.au>  <20111211122544.GC11504@redhat.com> <1323642447.19891.8.camel@pasglop>  <4EE56FCD.9030609@redhat.com> <87wra2tlue.fsf@rustcorp.com.au>  <4EEE9F16.8000501@redhat.com> <1324262474.30454.12.camel@pasglop>
In-Reply-To: <1324262474.30454.12.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/11 10:41, Benjamin Herrenschmidt wrote:
> On Mon, 2011-12-19 at 10:19 +0800, Amos Kong wrote:
>
>> I tested with the same environment and scenarios.
>> tested one scenarios for three times and compute the average for more
>> precision.
>>
>> Thanks, Amos
>>
>> --------- compare results -----------
>> Mon Dec 19 09:51:09 2011
>>
>> 1 - avg-old.netperf.exhost_guest.txt
>> 2 - avg-fixed.netperf.exhost_guest.txt
>
> The output is word wrapped and generally unreadable. Any chance you can
> provide us with a summary of the outcome ?
>
> Cheers,
> Ben.

Hi Ben,

The change of TCP_RR Throughput is very small.
external host -> guest: Some of throughput of TCP_STREAM and TCP_MAERTS 
reduced a little.
local host -> guest: Some of throughput of TCP_STREAM and TCP_MAERTS 
increased a little.


About compare result format:
---------------------------
>> 1 - avg-old.netperf.exhost_guest.txt

average result (tested 3 times) file of test 1
>> 2 - avg-fixed.netperf.exhost_guest.txt

average result file of test 2
>>
>> ======
>> TCP_STREAM

^^^ protocol

>>       sessions| size|throughput|   cpu| normalize|  #tx-pkts| #rx-pkts| #tx-byts|  #rx-byts| #re-trans| #tx-intr|  #rx-intr|  #io_exit|  #irq_inj|#tpkt/#exit| #rpkt/#irq
>> 1            1|   64|   1073.54| 10.50|       102|  ....

^^^ average result of old kernel, start netserver in guest, start 
netperf client(s) in external host

>> 2            1|   64|   1079.44| 10.29|       104|  ....

^^^ average result of fixed kernel

>> %             |  0.0|      +0.5|  -2.0|      +2.0|  ....

^^^ augment rate between test1 and test2

--------
sessions: netperf clients number
size: request/response sizes
#rx-pkts: received packets number
#rx-byts: received bytes number
#rx-intr: interrupt number for receive
#io_exit: io exit number
#irq_inj: injected irq number


Thanks, Amos.

