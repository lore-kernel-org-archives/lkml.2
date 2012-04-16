Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2DPNZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2DPNZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:25:13 -0400
Date: Mon, 16 Apr 2012 16:25:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org, xma@us.ibm.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com
Subject: Re: [PATCH 2/6] macvtap: zerocopy: fix truesize underestimation
Message-ID: <20120416132520.GA13113@redhat.com>
References: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
 <20120416060758.14140.40252.stgit@intel-e5620-16-2.englab.nay.redhat.com>
 <20120416071423.GA25396@redhat.com>
 <1334566193.28012.66.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334566193.28012.66.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:49:53AM +0200, Eric Dumazet wrote:
> On Mon, 2012-04-16 at 10:14 +0300, Michael S. Tsirkin wrote:
> > On Mon, Apr 16, 2012 at 02:07:59PM +0800, Jason Wang wrote:
> > > As the skb fragment were pinned/built from user pages, we should
> > > account the page instead of length for truesize.
> > > 
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > 
> > I'm not sure this is right: the skb does *not* consume the
> > whole page, userspace uses the rest of the page
> > for other skbs. So we'll end up accounting for the
> > same page twice.
> > Eric, what's the right thing to do here in your opinion?
> 
> Problem is we dont know for sure userspace wont free pages right after
> this syscall. So an evil application could consume more kernel memory
> than what socket limit allowed.
> 
> Its same problem with vmsplice(mem -> pipe) + splice(pipe -> socket)
> 
> When we clone skb with frags, resulting skb will have same truesize,
> even if the pages are shared ...
> 

I see, thanks for the clarification.

-- 
MST
