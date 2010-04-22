Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0DVI7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:59:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:23556 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab0DVI7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:59:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,255,1270450800"; 
   d="scan'208";a="615487923"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>
Date: Thu, 22 Apr 2010 16:57:56 +0800
Subject: RE: [RFC][PATCH v2 0/3] Provide a zero-copy method on KVM
	virtio-net.
Thread-Topic: [RFC][PATCH v2 0/3] Provide a zero-copy method on KVM
	virtio-net.
Thread-Index: AcrhLh94ExjlzDb9TDWF+hXUmrIJ4wAyJuTA
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D79026FAE0BDB@shsmsx502.ccr.corp.intel.com>
References: <1270193100-6769-1-git-send-email-xiaohui.xin@intel.com>
 <20100414152519.GA10792@redhat.com>
 <97F6D3BD476C464182C1B7BABF0B0AF5C18969CC@shzsmsx502.ccr.corp.intel.com>
 <20100415100546.GA17035@redhat.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79026FA95401@shsmsx502.ccr.corp.intel.com>
 <20100419102118.GA16198@redhat.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79026FAB1E5F@shsmsx502.ccr.corp.intel.com>
 <20100421083507.GA30855@redhat.com>
In-Reply-To: <20100421083507.GA30855@redhat.com>
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

Michael,

>Yes, I think this packet split mode probably maps well to mergeable buffer
>support. Note that
>1. Not all devices support large packets in this way, others might map
>   to indirect buffers better

Do the indirect buffers accord to deal with the skb->frag_list?

>   So we have to figure out how migration is going to work
Yes, different guest virtio-net driver may contain different features.
Does the qemu migration work with different features supported by virtio-net
driver now?

>2. It's up to guest driver whether to enable features such as
>   mergeable buffers and indirect buffers
>   So we have to figure out how to notify guest which mode
>   is optimal for a given device
Yes. When a device is binded, the mp device may query the capabilities from driver.
Actually, there is a structure now in mp device can do this, we can add some field
to support more.

>3. We don't want to depend on jumbo frames for decent performance
>   So we probably should support GSO/GRO
GSO is for the tx side, right? I think driver can handle it itself.
For GRO, I'm not sure it's easy or not. Basically, the mp device now
we have support is doing what raw socket is doing. The packets are not going to host stack.
-- 
MST
