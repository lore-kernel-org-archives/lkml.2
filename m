Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0FIIs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:48:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:41294 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab0FIIs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:48:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,390,1272870000"; 
   d="scan'208";a="574664112"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
       Stephen Hemminger <shemminger@vyatta.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Wed, 9 Jun 2010 16:48:48 +0800
Subject: RE: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
 external.
Thread-Topic: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
 external.
Thread-Index: AcsGFjuymVLa6ZyAReqD0rijjRWq4wBl9yGA
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D791100848F37@shsmsx502.ccr.corp.intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
	<20100606161348.427822fb@nehalam> <87pr03gu1c.fsf@basil.nowhere.org>
In-Reply-To: <87pr03gu1c.fsf@basil.nowhere.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Andi
>Kleen
>Sent: Monday, June 07, 2010 3:51 PM
>To: Stephen Hemminger
>Cc: Xin, Xiaohui; netdev@vger.kernel.org; kvm@vger.kernel.org;
>linux-kernel@vger.kernel.org; mst@redhat.com; mingo@elte.hu; davem@davemloft.net;
>herbert@gondor.apana.org.au; jdike@linux.intel.com
>Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from external.
>
>Stephen Hemminger <shemminger@vyatta.com> writes:
>
>> Still not sure this is a good idea for a couple of reasons:
>>
>> 1. We already have lots of special cases with skb's (frags and fraglist),
>>    and skb's travel through a lot of different parts of the kernel.  So any
>>    new change like this creates lots of exposed points for new bugs. Look
>>    at cases like MD5 TCP and netfilter, and forwarding these SKB's to ipsec
>>    and ppp and ...
>>
>> 2. SKB's can have infinite lifetime in the kernel. If these buffers come from
>>    a fixed size pool in an external device, they can easily all get tied up
>>    if you have a slow listener. What happens then?
>
>3. If they come from an internal pool what happens when the kernel runs
>low on memory? How is that pool balanced against other kernel
>memory users?
>
The size of the pool is limited by the virtqueue capacity now.
If the virtqueue is really huge, then how to balance on memory is a problem.
I did not consider it clearly how to tune it dynamically currently...

>-Andi
>
>--
>ak@linux.intel.com -- Speaking for myself only.
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
