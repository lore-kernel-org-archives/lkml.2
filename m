Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2G2Joa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 05:44:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab2G2Jo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 05:44:28 -0400
Date: Sun, 29 Jul 2012 12:44:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 4/5] virtio_net: multiqueue support
Message-ID: <20120729094451.GB8977@redhat.com>
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
 <1341484194-8108-5-git-send-email-jasowang@redhat.com>
 <20120720134014.GD16550@redhat.com>
 <500A9A72.20507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500A9A72.20507@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 02:02:58PM +0200, Sasha Levin wrote:
> On 07/20/2012 03:40 PM, Michael S. Tsirkin wrote:
> >> -	err = init_vqs(vi);
> >> > +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> >> > +		vi->has_cvq = true;
> >> > +
> > How about we disable multiqueue if there's no cvq?
> > Will make logic a bit simpler, won't it?
> 
> multiqueues don't really depend on cvq. Does this added complexity really justifies adding an artificial limit?

Well !cvq support is a legacy feature: the reason we support it
in driver is to avoid breaking on old hosts. Adding more code to that
path just doesn't make much sense since old hosts won't have mq.

-- 
MST
