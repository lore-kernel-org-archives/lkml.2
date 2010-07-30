Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0G3Ixz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 04:53:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:30793 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab0G3Ixw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 04:53:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,285,1278313200"; 
   d="scan'208";a="823208570"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Shirley Ma <mashirle@us.ibm.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Fri, 30 Jul 2010 16:53:03 +0800
Subject: RE: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
Thread-Topic: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
Thread-Index: AcsvbdP2So8Wpr8uSbuirl5Bo+pEOQAUJBjA
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D791BAB307158@shsmsx502.ccr.corp.intel.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
 <1280442682.9058.15.camel@localhost.localdomain>
In-Reply-To: <1280442682.9058.15.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Hello Xiaohui,
>
>On Thu, 2010-07-29 at 19:14 +0800, xiaohui.xin@intel.com wrote:
>> The idea is simple, just to pin the guest VM user space and then
>> let host NIC driver has the chance to directly DMA to it.
>> The patches are based on vhost-net backend driver. We add a device
>> which provides proto_ops as sendmsg/recvmsg to vhost-net to
>> send/recv directly to/from the NIC driver. KVM guest who use the
>> vhost-net backend may bind any ethX interface in the host side to
>> get copyless data transfer thru guest virtio-net frontend.
>
>Since vhost-net already supports macvtap/tun backends, do you think
>whether it's better to implement zero copy in macvtap/tun than inducing
>a new media passthrough device here?
>

I'm not sure if there will be more duplicated code in the kernel.

>> Our goal is to improve the bandwidth and reduce the CPU usage.
>> Exact performance data will be provided later.
>
>I did some vhost performance measurement over 10Gb ixgbe, and found that
>in order to get consistent BW results, netperf/netserver, qemu, vhost
>threads smp affinities are required.
>
>Looking forward to these results for small message size comparison. For
>large message size 10Gb ixgbe BW already reached by doing vhost smp
>affinity w/i offloading support, we will see how much CPU utilization it
>can be reduced.
>
>Please provide latency results as well. I did some experimental on
>macvtap zero copy sendmsg, what I have found that get_user_pages latency
>pretty high.
>
Ok, I will try that.

>Thanks
>Shirley
>
>
>

