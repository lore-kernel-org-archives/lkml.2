Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966644Ab2EPDSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 23:18:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845Ab2EPDSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 23:18:02 -0400
Message-ID: <4FB31C5F.1000000@redhat.com>
Date: Wed, 16 May 2012 11:17:51 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
Subject: Re: [V2 PATCH 4/9] macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only
 when skb is built successfully
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>  <20120502034206.11782.91643.stgit@amd-6168-8-1.englab.nay.redhat.com> <1337103843.8220.22.camel@oc3660625478.ibm.com>
In-Reply-To: <1337103843.8220.22.camel@oc3660625478.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 01:44 AM, Shirley Ma wrote:
> On Wed, 2012-05-02 at 11:42 +0800, Jason Wang wrote:
>> Current the SKBTX_DEV_ZEROCOPY is set unconditionally after
>> zerocopy_sg_from_iovec(), this would lead NULL pointer when macvtap
>> fails to build zerocopy skb because destructor_arg was not
>> initialized. Solve this by set this flag after the skb were built
>> successfully.
> I thought this flag was needed for zerocopy skb free even in err case.
> I've checked it back again, it's OK to move the flag after the skb
> successfully built. Or we can fix it by modify skb free with
> destructor_arg NULL check as below:
> ...
> skb_release_data() {
> ...
>                  if (skb_shinfo(skb)->tx_flags&  SKBTX_DEV_ZEROCOPY) {
>                          struct ubuf_info *uarg;
>
>                          uarg = skb_shinfo(skb)->destructor_arg;
>                          if (uarg&&  uarg->callback)
>                                  uarg->callback(uarg);
>                  }
>
> ...
> }
> Thanks
> Shirley
>
Yes, both are ok. Since the code were merged, let's just use current method.
