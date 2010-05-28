Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab0E1BNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:13:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:32098 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab0E1BNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,315,1272870000"; 
   d="scan'208";a="571242444"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Date: Fri, 28 May 2010 09:13:29 +0800
Subject: RE: issue about virtio-net driver to suppoprt vhost mergeable
	buffer with zero-copy to support PS mode
Thread-Topic: issue about virtio-net driver to suppoprt vhost mergeable
	buffer with zero-copy to support PS mode
Thread-Index: Acr9dhu4FOb2eQnNSnOUd4t4eF/m6wAi5S3A
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D790B7958EBD3@shsmsx502.ccr.corp.intel.com>
References: <F2E9EB7348B8264F86B6AB8151CE2D790B7958E740@shsmsx502.ccr.corp.intel.com>
 <20100527082025.GA5579@redhat.com>
In-Reply-To: <20100527082025.GA5579@redhat.com>
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
What's you have suggested could avoid to taint the guest virtio-net driver. Really thanks!
For the two alternative, the first will do more trick with driver or net-core stuff. So currently, I prefer to try the second one. Anyway, let me have a good think of it. Thanks!

Thanks
Xiaohui

>-----Original Message-----
>From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of
>Michael S. Tsirkin
>Sent: Thursday, May 27, 2010 4:20 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Herbert
>Xu
>Subject: Re: issue about virtio-net driver to suppoprt vhost mergeable buffer with zero-copy
>to support PS mode
>
>On Thu, May 27, 2010 at 09:21:02AM +0800, Xin, Xiaohui wrote:
>> Michael,
>> I'm now looking into the vhost mergeable buffer, and I tried to use it to support PS mode
>with zero-copy. And I found an issue there that I have to modify the guest virito-net driver.
>>
>> When guest virtio-net driver submits mergeable buffers, it submits multiple pages outside.
>In zero-copy case, vhost cannot know which page is used to put header, and which page is
>used to put payload. Then vhost can only reserves 12 bytes for each page. That means, the
>page_offset of the payload DMAed into the guest buffer is always 12 bytes. But guest
>virtio-net driver always use offset 0 to put the data (See receive_mergeable()). That's where
>the zero-copy use mergeable buffer must modify.
>>
>> Have I missed something here? And how do you think about it?
>>
>> Thanks
>> Xiaohui
>
>Maybe you can teach the hardware skip the first 12 bytes: qemu will
>call an ioctl telling hardware what the virtio header size is.
>This is how we plan to do it for tap.
>
>Alternatively, buffers can be used in any order.
>So we can have hardware use N buffers for the packet, and then
>have vhost put the header in buffer N+1.
>
>--
>MST
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
