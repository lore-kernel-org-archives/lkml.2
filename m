Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2G2Jtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 05:49:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab2G2Jtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 05:49:51 -0400
Date: Sun, 29 Jul 2012 12:50:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mashirle@us.ibm.com, krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 4/5] virtio_net: multiqueue support
Message-ID: <20120729095021.GC8977@redhat.com>
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
 <1341484194-8108-5-git-send-email-jasowang@redhat.com>
 <20120720134014.GD16550@redhat.com>
 <500CE5B3.3040404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500CE5B3.3040404@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 01:48:35PM +0800, Jason Wang wrote:
> >>+	}
> >>
> >>-	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ)) {
> >>+	ret = vi->vdev->config->find_vqs(vi->vdev, total_vqs, vqs, callbacks,
> >>+					 (const char **)names);
> >>+	if (ret)
> >>+		goto err;
> >>+
> >>+	if (vi->has_cvq)
> >>  		vi->cvq = vqs[2];
> >>
> >>-		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
> >>-			vi->dev->features |= NETIF_F_HW_VLAN_FILTER;
> >>+	for (i = 0; i<  vi->num_queue_pairs * 2; i += 2) {
> >>+		int j = i == 0 ? i : i + vi->has_cvq;
> >>+		vi->rq[i / 2]->vq = vqs[j];
> >>+		vi->sq[i / 2]->vq = vqs[j + 1];
> >Same here.
> 
> Consider the code is really simple, seem no need to use helpers.

Well it was not simple to at least one reader :)
The problem is not this logic is complex,
it is that it is spread all over the code.

If we had e.g. vnet_tx_vqn_to_queuenum vnet_tx_queuenum_to_vqn
and same for rx, then the logic would all be
in one place, and have a tidy comment on top explaining
the VQ numbering scheme.

-- 
MST
