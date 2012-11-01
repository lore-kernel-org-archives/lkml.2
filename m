Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936061Ab2KAQOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:14:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415Ab2KAQOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:14:00 -0400
Date: Thu, 1 Nov 2012 18:16:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: vyasevic@redhat.com, edumazet@google.com, akpm@linux-foundation.org,
        alexander.h.duyck@intel.com, Ian.Campbell@citrix.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 net-next 1/8] skb: report completion status for zero
 copy skbs
Message-ID: <20121101161611.GA9410@redhat.com>
References: <cover.1351679008.git.mst@redhat.com>
 <0dc176ed796ff5ac7164b6c18cc75d64c2a2317e.1351679008.git.mst@redhat.com>
 <20121101.115024.1422610516561380154.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101.115024.1422610516561380154.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 11:50:24AM -0400, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Wed, 31 Oct 2012 12:31:06 +0200
> 
> > -void vhost_zerocopy_callback(struct ubuf_info *ubuf)
> > +void vhost_zerocopy_callback(struct ubuf_info *ubuf, int zerocopy_status)
> 
> If you're only reporting true/false values, even just for now,
> please use 'bool' for this.

In fact next patch reports -ENOMEM when tun hits OOM so callback can
distinguish between copy (>0 value) and error (<0 value)
and reduce zerocopy more aggressively in case of errors.

The *callback* in vhost-net currently handles all non-zero
values identically, but I am not sure it's the optimal behaviour
so I thought it's worth it to give callbacks the info.

Do you think it's over-engineering, or a good idea?

-- 
MST
