Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab0FYCIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 22:08:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:15973 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab0FYCIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 22:08:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,478,1272870000"; 
   d="scan'208";a="579709947"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
       "Dong, Eddie" <eddie.dong@intel.com>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Fri, 25 Jun 2010 10:07:34 +0800
Subject: RE: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Topic: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Index: AcsThT/Rm7uoRx/+TDOLr+CCct8P8gAhaLEg
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D7916AFE9AE7C@shsmsx502.ccr.corp.intel.com>
References: <20100608052744.GA21547@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791100848F9F@shsmsx502.ccr.corp.intel.com>
 <20100611052112.GA25649@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791210AA4475@shsmsx502.ccr.corp.intel.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com>
 <20100617112119.GB1515@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com>
 <1A42CE6F5F474C41B63392A5F80372B21F58CD9A@shsmsx501.ccr.corp.intel.com>
 <20100623095254.GA32491@gondor.apana.org.au>
 <1A42CE6F5F474C41B63392A5F80372B21F58CE7F@shsmsx501.ccr.corp.intel.com>
 <20100624100836.GA16220@gondor.apana.org.au>
In-Reply-To: <20100624100836.GA16220@gondor.apana.org.au>
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

Herbert,
That's why I have sent you the patch for guest virtio-net driver. I reserved 512 bytes in each page, then I can always have the space to copy and avoid the backend memory used up issue.

Thanks
Xiaohui

>-----Original Message-----
>From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
>Sent: Thursday, June 24, 2010 6:09 PM
>To: Dong, Eddie
>Cc: Xin, Xiaohui; Stephen Hemminger; netdev@vger.kernel.org; kvm@vger.kernel.org;
>linux-kernel@vger.kernel.org; mst@redhat.com; mingo@elte.hu; davem@davemloft.net;
>jdike@linux.intel.com
>Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from external.
>
>On Wed, Jun 23, 2010 at 06:05:41PM +0800, Dong, Eddie wrote:
>>
>> I mean once the frontend side driver post the buffers to the backend driver, the backend
>driver will "immediately" use that buffers to compose skb or gro_frags and post them to the
>assigned host NIC driver as receive buffers. In that case, if the backend driver recieves a
>packet from the NIC that requires to do copy, it may be unable to find additional free guest
>buffer because all of them are already used by the NIC driver. We have to reserve some guest
>buffers for the possible copy even if the buffer address is not identified by original skb :(
>
>OK I see what you mean.  Can you tell me how does Xiaohui's
>previous patch-set deal with this problem?
>
>Thanks,
>--
>Visit Openswan at http://www.openswan.org/
>Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
>Home Page: http://gondor.apana.org.au/~herbert/
>PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
