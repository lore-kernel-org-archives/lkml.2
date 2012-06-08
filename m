Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2FHDcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:32:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab2FHDcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:32:14 -0400
Message-ID: <4FD1728E.20802@redhat.com>
Date: Fri, 08 Jun 2012 11:33:34 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Rick Jones <rick.jones2@hp.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [V2 RFC net-next PATCH 2/2] virtio_net: export more statistics
 through ethtool
References: <20120606075208.29081.75284.stgit@amd-6168-8-1.englab.nay.redhat.com>  <20120606075217.29081.30713.stgit@amd-6168-8-1.englab.nay.redhat.com>  <1339089306.2770.10.camel@bwh-desktop.uk.solarflarecom.com>  <20120607.130512.219951433412203999.davem@davemloft.net>  <1339100649.2770.20.camel@bwh-desktop.uk.solarflarecom.com>  <4FD11194.2040405@hp.com> <1339102567.2770.25.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1339102567.2770.25.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 04:56 AM, Ben Hutchings wrote:
> On Thu, 2012-06-07 at 13:39 -0700, Rick Jones wrote:
>> On 06/07/2012 01:24 PM, Ben Hutchings wrote:
>>> On Thu, 2012-06-07 at 13:05 -0700, David Miller wrote:
>>>> From: Ben Hutchings<bhutchings@solarflare.com>
>>>> Date: Thu, 7 Jun 2012 18:15:06 +0100
>>>>
>>>>> I would really like to see some sort of convention for presenting
>>>>> per-queue statistics through ethtool.  At the moment we have a complete
>>>>> mess of different formats:
>>>> Indeed.  Probably ${QUEUE_TYPE}-${INDEX}-${STATISTIC} is best.
>>>> With an agreed upon list of queue types such as "rx", "tx", "rxtx"
>>>> etc.
>>> I think we should leave the type names open-ended, as there are other
>>> useful groupings like per-virtual-port.  In that case the separator
>>> should be chosen to allow arbitrary type names without ambiguity.
>> So you mean like something along the lines of the presence of say '.'
>> indicating indent a level:
>>
>> rx_bytes:  1234
>>       myqueue1.rx_bytes: 234
>>       myqueue2.rx_bytes: 345
>>       ...
> Most drivers seem to want this sort of ordering/grouping:
>
> group0.foo
> group0.bar
> ...
> group1.foo
> group1.bar
> ...
>
> but if we have a standard way of indicating groups of statistics then
> the user can choose whether they want to reorder by type name.
>
> Ben.
>

Yes, it looks to me that the per-queue satistics were better:

- Simple and less synchronization.
- Good for future virtio-net multiqueue merging.
