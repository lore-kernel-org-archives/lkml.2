Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624Ab2KBCSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:18:15 -0400
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29912 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab2KBCSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:18:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6883"; a="3726814"
X-IronPort-AV: E=Sophos;i="4.80,696,1344236400"; 
   d="scan'208";a="362398116"
Message-ID: <50932D63.3080308@qti.qualcomm.com>
Date: Thu, 1 Nov 2012 19:18:11 -0700
From: Max Krasnyansky <maxk@qti.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: <davem@davemloft.net>, <mst@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <edumazet@google.com>,
        <krkumar2@in.ibm.com>, <ernesto.martin@viasat.com>,
        <haixiao@juniper.net>
Subject: Re: [net-next v5 0/7] Multiqueue support in tuntap
References: <1351748762-3455-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1351748762-3455-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 10:45 PM, Jason Wang wrote:
> Hello All:
> 
> This is an update of multiqueue support in tuntap from V3. Please consider to
> merge.
> 
> The main idea for this series is to let tun/tap device to be benefited from
> multiqueue network cards and multi-core host. We used to have a single queue for
> tuntap which could be a bottleneck in a multiqueue/core environment. So this
> series let the device could be attched with multiple sockets and expose them
> through fd to the userspace as multiqueues. The sereis were orignally designed
> to serve as backend for multiqueue virtio-net in KVM, but the design is generic
> for other application to be used.
> 
> Some quick overview of the design:
> 
> - Moving socket from tun_device to tun_file.
> - Allowing multiple sockets to be attached to a tun/tap devices.
> - Using RCU to synchronize the data path and system call.
> - Two new ioctls were added for the usespace to attach and detach socket to the
>   device.
> - API compatibility were maintained without userspace notable changes, so legacy
>   userspace that only use one queue won't need any changes.
> - A flow(rxhash) to queue table were maintained by tuntap which choose the txq
>   based on the last rxq where it comes.

I'm still trying to wrap my head around the new locking/RCU stuff but it looks like
Paul and others already looked at it.

Otherwise looks good to me.

btw In the description above you really meant allowing for attaching multiple file
descriptors not sockets.

Thanks
Max


