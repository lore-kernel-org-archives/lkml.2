Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0FYLLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab0FYLLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:11:43 -0400
Date: Fri, 25 Jun 2010 14:06:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Dong, Eddie" <eddie.dong@intel.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
       "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>
Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Message-ID: <20100625110629.GB16444@redhat.com>
References: <20100611052112.GA25649@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D791210AA4475@shsmsx502.ccr.corp.intel.com> <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com> <20100617112119.GB1515@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com> <1A42CE6F5F474C41B63392A5F80372B21F58CD9A@shsmsx501.ccr.corp.intel.com> <20100623095254.GA32491@gondor.apana.org.au> <1A42CE6F5F474C41B63392A5F80372B21F58CE7F@shsmsx501.ccr.corp.intel.com> <20100624100836.GA16220@gondor.apana.org.au> <1A42CE6F5F474C41B63392A5F80372B21F58D666@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1A42CE6F5F474C41B63392A5F80372B21F58D666@shsmsx501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 09:03:46AM +0800, Dong, Eddie wrote:
> Herbert Xu wrote:
> > On Wed, Jun 23, 2010 at 06:05:41PM +0800, Dong, Eddie wrote:
> >> 
> >> I mean once the frontend side driver post the buffers to the backend
> >> driver, the backend driver will "immediately" use that buffers to
> >> compose skb or gro_frags and post them to the assigned host NIC
> >> driver as receive buffers. In that case, if the backend driver
> >> recieves a packet from the NIC that requires to do copy, it may be
> >> unable to find additional free guest buffer because all of them are
> >> already used by the NIC driver. We have to reserve some guest
> >> buffers for the possible copy even if the buffer address is not
> >> identified by original skb :(        
> > 
> > OK I see what you mean.  Can you tell me how does Xiaohui's
> > previous patch-set deal with this problem?
> > 
> > Thanks,
> 
> In current patch, each SKB for the assigned device (SRIOV VF or NIC or a complete queue pairs) uses the buffer from guest, so it eliminates copy completely in software and requires hardware to do so. If we can have an additonal place to store the buffer per skb (may cause copy later on), we can do copy later on or re-post the buffer to assigned NIC driver later on. But that may be not very clean either :(
> BTW, some hardware may require certain level of packet copy such as for broadcast packets in very old VMDq device, which is not addressed in previous Xiaohui's patch yet. We may address this by implementing an additional virtqueue between guest and host for slow path (broadcast packets only here) with additinal complexity in FE/BE driver. 
> 
> Thx, Eddie

guest posts a large number of buffers to the host.
Host can use them any way it wants to, and in any order,
for example reserve half the buffers for the copy.

This might waste some memory if buffers are used
only partially, but let's worry about this later.

-- 
MST
