Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2DQFdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:33:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64059 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2DQFdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:33:32 -0400
Subject: Re: [PATCH 3/6] macvtap: zerocopy: validate vector length before
 pinning user pages
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, xma@us.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, mst@redhat.com, ebiederm@xmission.com
In-Reply-To: <4F8BD68F.7070708@redhat.com>
References: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
	 <20120416060807.14140.96229.stgit@intel-e5620-16-2.englab.nay.redhat.com>
	 <1334559183.28012.45.camel@edumazet-glaptop>  <4F8BD68F.7070708@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Apr 2012 07:33:28 +0200
Message-ID: <1334640808.2472.6.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 16:21 +0800, Jason Wang wrote:
> Hi:
> On 04/16/2012 02:53 PM, Eric Dumazet wrote:
> 	if ((num_pages != size) ||
> >>   		    (num_pages>  MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags))
> >>
> > Hi Jason
> >
> > Why is -EFAULT the right error code ?
> 
> E2BIG or is there any error code you prefer?

Might be good yes.

However it sounds strange user cant write any size he wants (and kernel
needs to build several skbs to fulfill user request)



