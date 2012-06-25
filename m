Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2FYONw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:13:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:43205 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab2FYONu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:13:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115770771"
Message-ID: <4FE87217.5020208@intel.com>
Date: Mon, 25 Jun 2012 07:13:43 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, mashirle@us.ibm.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, akong@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org
Subject: Re: [net-next RFC V4 PATCH 0/4] Multiqueue virtio-net
References: <20120625090829.7263.65026.stgit@amd-6168-8-1.englab.nay.redhat.com> <20120625100758.GB19169@redhat.com>
In-Reply-To: <20120625100758.GB19169@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/2012 3:07 AM, Michael S. Tsirkin wrote:
> On Mon, Jun 25, 2012 at 05:16:48PM +0800, Jason Wang wrote:
>> Hello All:
>>
>> This series is an update version of multiqueue virtio-net driver based on
>> Krishna Kumar's work to let virtio-net use multiple rx/tx queues to do the
>> packets reception and transmission. Please review and comments.
>>
>> Test Environment:
>> - Intel(R) Xeon(R) CPU E5620 @ 2.40GHz, 8 cores 2 numa nodes
>> - Two directed connected 82599
>>
>> Test Summary:
>>
>> - Highlights: huge improvements on TCP_RR test
>> - Lowlights: regression on small packet transmission, higher cpu utilization
>>               than single queue, need further optimization
>
> Didn't review yet, reacting this this paragraph:
>
> To avoid regressions, it seems reasonable to make
> the device use a single queue by default for now.
> Add a way to switch multiqueue on/off using ethtool.
>
> This way guest admin can tune the device for the
> workload manually until we manage to imlement some
> self-tuning heuristics.
>

Ethtool already has this switch 'ethtool -L' can be
used to set the number tx/rx channels. So you would
likely just need to add a set_channels hook.

.John
