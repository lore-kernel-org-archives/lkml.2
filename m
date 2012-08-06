Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2HFMc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab2HFMc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:32:27 -0400
Message-ID: <1344256306.14728.29.camel@cr0>
Subject: Re: [PATCH 1/7] netpoll: use GFP_ATOMIC in slave_enable_netpoll()
 and __netpoll_setup()
From: Cong Wang <amwang@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Aug 2012 20:31:46 +0800
In-Reply-To: <1344246244.26674.0.camel@edumazet-glaptop>
References: <1343403484-29347-1-git-send-email-amwang@redhat.com>
	 <1343403484-29347-2-git-send-email-amwang@redhat.com>
	 <1343985428.9299.868.camel@edumazet-glaptop> <1343986487.20871.2.camel@cr0>
	 <1343988623.9299.932.camel@edumazet-glaptop>
	 <1344244118.14728.28.camel@cr0> <1344246244.26674.0.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 11:44 +0200, Eric Dumazet wrote:
> On Mon, 2012-08-06 at 17:08 +0800, Cong Wang wrote:
> > On Fri, 2012-08-03 at 12:10 +0200, Eric Dumazet wrote: 
> > > 
> > > I did this , just take it ;)
> > 
> > Do we have to pass gfp to ->ndo_netpoll_setup() too? It seems no, so far
> > I don't think we have to do that.
> > 
> > Thanks.
> > 
> 
> It is needed.
> 
> ->ndo_netpoll_setup() is called from __netpoll_setup()
> 
> So it would make no sense to allow GFP_KERNEL allocations in
> ndo_netpoll_setup() hgandlers if we called __netpoll_setup() with
> GFP_ATOMIC gfp
> 

I see your point. Thanks!


