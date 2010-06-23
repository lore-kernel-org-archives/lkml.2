Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0FWKIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:08:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:27469 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab0FWKIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:08:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,466,1272870000"; 
   d="scan'208";a="579056480"
From: "Dong, Eddie" <eddie.dong@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>
Date: Wed, 23 Jun 2010 18:05:41 +0800
Subject: RE: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Topic: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Index: AcsSud77JKQHm149QK6yGTDpAKtH4AAAMzRg
Message-ID: <1A42CE6F5F474C41B63392A5F80372B21F58CE7F@shsmsx501.ccr.corp.intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
 <20100606161348.427822fb@nehalam>
 <20100608052744.GA21547@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791100848F9F@shsmsx502.ccr.corp.intel.com>
 <20100611052112.GA25649@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791210AA4475@shsmsx502.ccr.corp.intel.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com>
 <20100617112119.GB1515@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com>
 <1A42CE6F5F474C41B63392A5F80372B21F58CD9A@shsmsx501.ccr.corp.intel.com>
 <20100623095254.GA32491@gondor.apana.org.au>
In-Reply-To: <20100623095254.GA32491@gondor.apana.org.au>
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

Herbert Xu wrote:
> On Wed, Jun 23, 2010 at 04:09:40PM +0800, Dong, Eddie wrote:
>> 
>> Xiaohui & Herbert:
>> 	Mixing copy of head & 0-copy of bulk data imposes additional
>> 	challange to find the guest buffer. The backend driver may be
>> unable to find a spare guest buffer from virtqueue at that time
>> which may block the receiving process then. Can't we completely
>> eliminate netdev_alloc_skb here? Assigning guest buffer at this time
>> makes life much easier.    
> 
> I'm not sure I understand you concern.  If you mean that when
> the guest doesn't give enough pages to the host and the host
> can't receive on behalf of the guest then isn't that already
> the case with the original patch-set?
> 

I mean once the frontend side driver post the buffers to the backend driver, the backend driver will "immediately" use that buffers to compose skb or gro_frags and post them to the assigned host NIC driver as receive buffers. In that case, if the backend driver recieves a packet from the NIC that requires to do copy, it may be unable to find additional free guest buffer because all of them are already used by the NIC driver. We have to reserve some guest buffers for the possible copy even if the buffer address is not identified by original skb :(

Thx, Eddie
