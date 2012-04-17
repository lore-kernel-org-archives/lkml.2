Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2DQFnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:43:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2DQFnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:43:51 -0400
Date: Tue, 17 Apr 2012 08:43:58 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org, xma@us.ibm.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com
Subject: Re: [PATCH 3/6] macvtap: zerocopy: validate vector length before
 pinning user pages
Message-ID: <20120417054356.GB31278@redhat.com>
References: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
 <20120416060807.14140.96229.stgit@intel-e5620-16-2.englab.nay.redhat.com>
 <1334559183.28012.45.camel@edumazet-glaptop>
 <4F8BD68F.7070708@redhat.com>
 <1334640808.2472.6.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334640808.2472.6.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 07:33:28AM +0200, Eric Dumazet wrote:
> On Mon, 2012-04-16 at 16:21 +0800, Jason Wang wrote:
> > Hi:
> > On 04/16/2012 02:53 PM, Eric Dumazet wrote:
> > 	if ((num_pages != size) ||
> > >>   		    (num_pages>  MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags))
> > >>
> > > Hi Jason
> > >
> > > Why is -EFAULT the right error code ?
> > 
> > E2BIG or is there any error code you prefer?
> 
> Might be good yes.
> 
> However it sounds strange user cant write any size he wants (and kernel
> needs to build several skbs to fulfill user request)

We never supported arbitrary length writes:
macvtap is exactly like packet sockets in this regard.

-- 
MST

