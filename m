Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2FYRwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:52:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43683 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab2FYRwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:52:23 -0400
Message-ID: <4FE8A4B6.1080200@us.ibm.com>
Date: Mon, 25 Jun 2012 10:49:42 -0700
From: Sridhar Samudrala <sri@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        mst@redhat.com, netdev@vger.kernel.org, mashirle@us.ibm.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, akong@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org
Subject: Re: [net-next RFC V4 PATCH 0/4] Multiqueue virtio-net
References: <20120625090829.7263.65026.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120625090829.7263.65026.stgit@amd-6168-8-1.englab.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062517-5112-0000-0000-000009746EC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/2012 2:16 AM, Jason Wang wrote:
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
>               than single queue, need further optimization
Does this also scale with increased number of VMs?

Thanks
Sridhar
>
> Analysis of the performance result:
>
> - I count the number of packets sending/receiving during the test, and
>    multiqueue show much more ability in terms of packets per second.
>
> - For the tx regression, multiqueue send about 1-2 times of more packets
>    compared to single queue, and the packets size were much smaller than single
>    queue does. I suspect tcp does less batching in multiqueue, so I hack the
>    tcp_write_xmit() to forece more batching, multiqueue works as well as
>    singlequeue for both small transmission and throughput
>
> - I didn't pack the accelerate RFS with virtio-net in this sereis as it still
>    need further shaping, for the one that interested in this please see:
>    http://www.mail-archive.com/kvm@vger.kernel.org/msg64111.html
>
>

