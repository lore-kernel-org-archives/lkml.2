Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2EBFuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:50:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab2EBFuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:50:06 -0400
Date: Wed, 2 May 2012 08:50:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
Subject: Re: [V2 PATCH 0/9] vhost/macvtap zeropcopy fixes
Message-ID: <20120502055008.GA29319@redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:41:21AM +0800, Jason Wang wrote:
> This is an updated since the last series of vhost/macvtap zerocopy fixes which
> fixes the the possible transmission stall, host kernel stack overflow and other
> misc fixes.
> 
> Changes from V1:
> - Addressing comments from Eric and Michael.
> - Adding more fixes into the seires.

Thanks for fixing this.
Acked-by: Michael S. Tsirkin <mst@redhat.com>

Dave, can you merge this for 3.4 please?
Thanks!

> ---
> 
> Jason Wang (9):
>       macvtap: zerocopy: fix offset calculation when building skb
>       macvtap: zerocopy: fix truesize underestimation
>       macvtap: zerocopy: put page when fail to get all requested user pages
>       macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only when skb is built successfully
>       macvtap: zerocopy: validate vectors before building skb
>       vhost_net: zerocopy: fix possible NULL pointer dereference of vq->bufs
>       vhost_net: re-poll only on EAGAIN or ENOBUFS
>       vhost_net: zerocopy: adding and signalling immediately when fully copied
>       vhost: zerocopy: poll vq in zerocopy callback
> 
> 
>  drivers/net/macvtap.c |   57 ++++++++++++++++++++++++++++++++++---------------
>  drivers/vhost/net.c   |    7 ++++--
>  drivers/vhost/vhost.c |    1 +
>  3 files changed, 46 insertions(+), 19 deletions(-)
> 
> -- 
> Jason Wang
