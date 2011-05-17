Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1EQP2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab1EQP2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:28:52 -0400
Date: Tue, 17 May 2011 18:28:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 4/6 net-next] vhost: vhost TX zero-copy support
Message-ID: <20110517152840.GA2389@redhat.com>
References: <1305574484.3456.30.camel@localhost.localdomain>
 <20110516204540.GD18148@redhat.com>
 <1305579414.3456.49.camel@localhost.localdomain>
 <20110516212401.GF18148@redhat.com>
 <1305606683.10756.3.camel@localhost.localdomain>
 <20110517055503.GA26989@redhat.com>
 <1305645734.10756.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305645734.10756.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 08:22:14AM -0700, Shirley Ma wrote:
> On Tue, 2011-05-17 at 08:55 +0300, Michael S. Tsirkin wrote:
> > Something in your patch that overwrites the id in vhost
> > and makes it put the wrong id in the used ring?
> > 
> > By the way, need to keep in mind that a guest can
> > give us the same head twice, need to make sure this
> > at least does not corrupt host memory.
> 
> I think I didn't explain the problem very well here.
> 
> This patch doesn't overwrite the id. It just keeps the same coming
> sequence from "head return vhost_get_vq_desc()" to pass to
> vhost_add_used.
> 
> The same ids can be used many times once it passes to guest from
> vhost_add_used. There is no problem. The zero copy patch doesn't have
> any issue.
> 
> The problem is the order of head from return vhost_get_vq_desc should be
> in sequence when it passes to vhost_add_used.

Which is the order the descriptors are put on avail ring.
By design, guest should not depend on used ring entries
being in order with avail ring (and btw with virtio block,
they aren't). If it does, it's a bug I think.

> The original code has no problem, because it gets one head and pass that
> head to vhost_add_used one by one once done the copy. So it's in
> sequence.
> 
> This issue can easily recreate without zerocopy patch by simply changing
> the order from "head return vhost_get_vq_desc" when passing to
> vhost_add_used.
> 
> Thanks
> Shirley

Ah, did you try that? Could you post this patch pls?
This seems to imply a bug in guest virtio.

-- 
MST
