Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1K2Tth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:49:37 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:7370 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1K2Ttg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:49:36 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371K1432N98dKzz1202hzzz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4ED53748.3060801@freescale.com>
Date: Tue, 29 Nov 2011 13:49:28 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Li Yang-R58472 <r58472@freescale.com>
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Shi Xuelin-B29237 <B29237@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] fsldma: fix performance degradation by optimizing
 spinlock use.
References: <1321937705-19587-1-git-send-email-b29237@freescale.com> <20111122185924.GA23323@ovro.caltech.edu> <DBB740589CE8814680DECFE34BE197AB148CDD@039-SN1MPN1-006.039d.mgd.msft.net> <20111128163814.GA10919@ovro.caltech.edu> <3F607A5180246847A760FD34122A1E052E07B7@039-SN1MPN1-003.039d.mgd.msft.net>
In-Reply-To: <3F607A5180246847A760FD34122A1E052E07B7@039-SN1MPN1-003.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 09:19 PM, Li Yang-R58472 wrote:
>> Subject: Re: [PATCH][RFC] fsldma: fix performance degradation by optimizing
>> spinlock use.
>>
>> On Thu, Nov 24, 2011 at 08:12:25AM +0000, Shi Xuelin-B29237 wrote:
>>> Hi Ira,
>>>
>>> Thanks for your review.
>>>
>>> After second thought, I think your scenario may not occur.
>>> Because the cookie 20 we query must be returned by fsl_dma_tx_submit(...) in
>> practice.
>>> We never query a cookie not returned by fsl_dma_tx_submit(...).
>>>
>>
>> I agree about this part.
>>
>>> When we call fsl_tx_status(20), the chan->common.cookie is definitely wrote as
>> 20 and cpu2 could not read as 19.
>>>
>>
>> This is what I don't agree about. However, I'm not an expert on CPU cache vs.
>> memory accesses in an multi-processor system. The section titled "CACHE
>> COHERENCY" in Documentation/memory-barriers.txt leads me to believe that the
>> scenario I described is possible.
> 
> For Freescale PowerPC, the chip automatically takes care of cache coherency.  Even if this is a concern, spinlock can't address it.

Cache coherency is not the same thing as ordering -- and spinlocks do
address ordering, because there are memory barriers in the lock
implementation.

If you're relying on some non-universal ordering guarantee that all
chips with this device make, it needs to be documented explicitly what
you're assuming and why it's valid.

-Scott

