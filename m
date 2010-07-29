Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0G2Wba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 18:31:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52039 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab0G2Wb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 18:31:27 -0400
Subject: Re: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
From: Shirley Ma <mashirle@us.ibm.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 15:31:22 -0700
Message-ID: <1280442682.9058.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Xiaohui,

On Thu, 2010-07-29 at 19:14 +0800, xiaohui.xin@intel.com wrote:
> The idea is simple, just to pin the guest VM user space and then
> let host NIC driver has the chance to directly DMA to it. 
> The patches are based on vhost-net backend driver. We add a device
> which provides proto_ops as sendmsg/recvmsg to vhost-net to
> send/recv directly to/from the NIC driver. KVM guest who use the
> vhost-net backend may bind any ethX interface in the host side to
> get copyless data transfer thru guest virtio-net frontend.

Since vhost-net already supports macvtap/tun backends, do you think
whether it's better to implement zero copy in macvtap/tun than inducing
a new media passthrough device here? 

> Our goal is to improve the bandwidth and reduce the CPU usage.
> Exact performance data will be provided later.

I did some vhost performance measurement over 10Gb ixgbe, and found that
in order to get consistent BW results, netperf/netserver, qemu, vhost
threads smp affinities are required.

Looking forward to these results for small message size comparison. For
large message size 10Gb ixgbe BW already reached by doing vhost smp
affinity w/i offloading support, we will see how much CPU utilization it
can be reduced. 

Please provide latency results as well. I did some experimental on
macvtap zero copy sendmsg, what I have found that get_user_pages latency
pretty high.

Thanks
Shirley




