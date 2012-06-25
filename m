Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2FYKIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:08:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab2FYKIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:08:10 -0400
Date: Mon, 25 Jun 2012 13:07:58 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, mashirle@us.ibm.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, akong@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org
Subject: Re: [net-next RFC V4 PATCH 0/4] Multiqueue virtio-net
Message-ID: <20120625100758.GB19169@redhat.com>
References: <20120625090829.7263.65026.stgit@amd-6168-8-1.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625090829.7263.65026.stgit@amd-6168-8-1.englab.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 05:16:48PM +0800, Jason Wang wrote:
> Hello All:
> 
> This series is an update version of multiqueue virtio-net driver based on
> Krishna Kumar's work to let virtio-net use multiple rx/tx queues to do the
> packets reception and transmission. Please review and comments.
> 
> Test Environment:
> - Intel(R) Xeon(R) CPU E5620 @ 2.40GHz, 8 cores 2 numa nodes
> - Two directed connected 82599
> 
> Test Summary:
> 
> - Highlights: huge improvements on TCP_RR test
> - Lowlights: regression on small packet transmission, higher cpu utilization
>              than single queue, need further optimization

Didn't review yet, reacting this this paragraph:

To avoid regressions, it seems reasonable to make
the device use a single queue by default for now.
Add a way to switch multiqueue on/off using ethtool.

This way guest admin can tune the device for the
workload manually until we manage to imlement some
self-tuning heuristics.

-- 
MST
