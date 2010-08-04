Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab0HDCNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:13:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:22981 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab0HDCNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:13:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,313,1278313200"; 
   d="scan'208";a="307912746"
From: "Dong, Eddie" <eddie.dong@intel.com>
To: Arnd Bergmann <arnd@arndb.de>, Shirley Ma <mashirle@us.ibm.com>
CC: "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>
Date: Wed, 4 Aug 2010 10:06:05 +0800
Subject: RE: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
Thread-Topic: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
Thread-Index: AcswkzBWXHYtzPpKS8q3axBKY9jN0wC5XJ9A
Message-ID: <1A42CE6F5F474C41B63392A5F80372B228FCE7B1@shsmsx501.ccr.corp.intel.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
 <F2E9EB7348B8264F86B6AB8151CE2D791BAB307158@shsmsx502.ccr.corp.intel.com>
 <1280505112.9058.31.camel@localhost.localdomain>
 <201007311130.17000.arnd@arndb.de>
In-Reply-To: <201007311130.17000.arnd@arndb.de>
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

Arnd Bergmann wrote:
> On Friday 30 July 2010 17:51:52 Shirley Ma wrote:
>> On Fri, 2010-07-30 at 16:53 +0800, Xin, Xiaohui wrote:
>>>> Since vhost-net already supports macvtap/tun backends, do you think
>>>> whether it's better to implement zero copy in macvtap/tun than
>>>> inducing a new media passthrough device here?
>>>> 
>>> 
>>> I'm not sure if there will be more duplicated code in the kernel.
>> 
>> I think it should be less duplicated code in the kernel if we use
>> macvtap to support what media passthrough driver here. Since macvtap
>> has support virtio_net head and offloading already, the only missing
>> func is zero copy. Also QEMU supports macvtap, we just need add a
>> zero copy flag in option.
> 
> Yes, I fully agree and that was one of the intended directions for
> macvtap to start with. Thank you so much for following up on that,
> I've long been planning to work on macvtap zero-copy myself but it's
> now lower on my priorities, so it's good to hear that you made
> progress on it, even if there are still performance issues.
> 

But zero-copy is a Linux generic feature that can be used by other VMMs as well if the BE service drivers want to incorporate.  If we can make mp device VMM-agnostic (it may be not yet in current patch), that will help Linux more.


Thx, Eddie