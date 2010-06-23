Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab0FWINU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:13:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:29503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab0FWINR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:13:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,466,1272870000"; 
   d="scan'208";a="632812267"
From: "Dong, Eddie" <eddie.dong@intel.com>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>
Date: Wed, 23 Jun 2010 16:09:40 +0800
Subject: RE: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Topic: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Index: AcsODzkxPK6uVz5GQIqMA0G8bjeaHAAlw28gAQEiYkA=
Message-ID: <1A42CE6F5F474C41B63392A5F80372B21F58CD9A@shsmsx501.ccr.corp.intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
 <20100606161348.427822fb@nehalam>
 <20100608052744.GA21547@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791100848F9F@shsmsx502.ccr.corp.intel.com>
 <20100611052112.GA25649@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791210AA4475@shsmsx502.ccr.corp.intel.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com>
 <20100617112119.GB1515@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com>
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


> 3) As I have mentioned above, with this idea, netdev_alloc_skb() will
> allocate 
> as usual, the data pointed by skb->data will be copied into the first
> guest buffer. 
> That means we should reserve sufficient room in guest buffer. For PS
> mode 
> supported driver (for example ixgbe), the room will be more than 128.
> After 128bytes, 
> we will put the first frag data. Look into virtio-net.c the function
> page_to_skb() 
> and receive_mergeable(), that means we should modify guest virtio-net
> driver to 
> compute the offset as the parameter for skb_set_frag().
> 
> How do you think about this? Attached is a patch to how to modify the
> guest driver. 
> I reserve 512 bytes as an example, and transfer the header len of the
> skb in hdr->hdr_len. 
> 
Xiaohui & Herbert:
	Mixing copy of head & 0-copy of bulk data imposes additional challange to find the guest buffer. The backend driver may be unable to find a spare guest buffer from virtqueue at that time which may block the receiving process then.
	Can't we completely eliminate netdev_alloc_skb here? Assigning guest buffer at this time makes life much easier.
Thx, Eddie
