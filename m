Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2KDXsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 18:48:12 -0500
Received: from ozlabs.org ([203.10.76.45]:47787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2KDXrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 18:47:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        krkumar2@in.ibm.com
Cc: kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: Re: [rfc net-next v6 2/3] virtio_net: multiqueue support
In-Reply-To: <1351591403-23065-3-git-send-email-jasowang@redhat.com>
References: <1351591403-23065-1-git-send-email-jasowang@redhat.com> <1351591403-23065-3-git-send-email-jasowang@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 05 Nov 2012 09:46:58 +1030
Message-ID: <874nl5yn4k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> This addes multiqueue support to virtio_net driver. There's two mode supported:
> single queue pair mode and multiple queue pairs mode. An obvious
> difference compared with a physical mq card is that virtio-net reserve
> first two virtqueues when it is working in multiqueue mode, this is
> used for implementing adaptive mode switching in the future. The
> virtqueues that were in both mq and sq mode were initialized and only
> one queue pair (single queue mode) were used at default. User could
> use ethtool -L to switch to multiqueue mode withe the next patch.

Hi Jason,

        This first patch looks good, but conflates three things
together:
(1) Separate per-queue structures from struct virtnet_info to allow
    multiple queues.  This is the mechanical part of the patch.
(2) An annotation bugfix, see below.
(3) Enabling mq using a new feature and negotiation.

> @@ -700,7 +767,8 @@ static struct rtnl_link_stats64 *virtnet_stats(struct net_device *dev,
>  	unsigned int start;
>  
>  	for_each_possible_cpu(cpu) {
> -		struct virtnet_stats *stats = per_cpu_ptr(vi->stats, cpu);
> +		struct virtnet_stats __percpu *stats
> +			= per_cpu_ptr(vi->stats, cpu);
>  		u64 tpackets, tbytes, rpackets, rbytes;
>  
>  		do {

Cheers,
Rusty.
