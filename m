Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1DUO3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:29:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38021 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1DUO3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <1303328216.19336.18.camel@localhost.localdomain>
References: <1303328216.19336.18.camel@localhost.localdomain>
Date: Thu, 21 Apr 2011 10:29:04 -0400
Message-ID: <BANLkTi=ckukmCdOOvQc29vtYgxeiSMGqBw@mail.gmail.com>
Subject: Re: [PATCH V3 0/8] macvtap/vhost TX zero copy support
From: Jon Mason <jdmason@kudzu.us>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 3:36 PM, Shirley Ma <mashirle@us.ibm.com> wrote:
> This patchset add supports for TX zero-copy between guest and host
> kernel through vhost. It significantly reduces CPU utilization on the
> local host on which the guest is located (It reduced 30-50% CPU usage
> for vhost thread for single stream test). The patchset is based on
> previous submission and comments from the community regarding when/how
> to handle guest kernel buffers to be released. This is the simplest
> approach I can think of after comparing with several other solutions.
>
> This patchset includes:
>
> 1/8: Add a new sock zero-copy flag, SOCK_ZEROCOPY;
>
> 2/8: Add a new device flag, NETIF_F_ZEROCOPY for lower level device
> support zero-copy;
>
> 3/8: Add a new struct skb_ubuf_info in skb_share_info for userspace
> buffers release callback when lower device DMA has done for that skb;
>
> 4/8: Add vhost zero-copy callback in vhost when skb last refcnt is gone;
> add vhost_zerocopy_add_used_and_signal to notify guest to release TX skb
> buffers.
>
> 5/8: Add macvtap zero-copy in lower device when sending packet is
> greater than 128 bytes.
>
> 6/8: Add Chelsio 10Gb NIC to zero copy feature flag
>
> 7/8: Add Intel 10Gb NIC zero copy feature flag
>
> 8/8: Add Emulex 10Gb NIC zero copy feature flag

Why are only these 3 drivers getting support?  As far as I can tell,
the only requirement is HIGHDMA.  If this is the case, is there really
a need for an additional flag to support this?  If you can key off of
HIGHDMA, all devices that support this would get the benefit.



> The patchset is built against most recent linux 2.6.git. It has passed
> netperf/netserver multiple streams stress test on above NICs.
>
> The single stream test results from 2.6.37 kernel on Chelsio:
>
> 64K message size: copy_from_user dropped from 40% to 5%; vhost thread
> cpu utilization dropped from 76% to 28%
>
> I am collecting more test results against 2.6.39-rc3 kernel and will
> provide the test matrix later.
>
> Thanks
> Shirley
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
