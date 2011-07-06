Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1GFXYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:24:20 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34246 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab1GFXYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:24:19 -0400
Subject: Re: [PATCH V8 2/4 net-next] skbuff: skb supports zero-copy buffers
From: Shirley Ma <mashirle@us.ibm.com>
To: Zan Lynx <zlynx@acm.org>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E14E939.5040904@acm.org>
References: <1309990932.10209.19.camel@localhost.localdomain>
	 <4E14E939.5040904@acm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 16:24:14 -0700
Message-ID: <1309994654.10209.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 17:01 -0600, Zan Lynx wrote:
> On 7/6/2011 4:22 PM, Shirley Ma wrote:
> > This patch adds userspace buffers support in skb shared info. A new 
> > struct skb_ubuf_info is needed to maintain the userspace buffers
> > argument and index, a callback is used to notify userspace to
> release
> > the buffers once lower device has done DMA (Last reference to that
> skb
> > has gone).
> > 
> > If there is any userspace apps to reference these userspace buffers,
> > then these userspaces buffers will be copied into kernel. This way
> we
> > can prevent userspace apps from holding these userspace buffers too
> long.
> > 
> > Use destructor_arg to point to the userspace buffer info; a new tx
> flags
> > SKBTX_DEV_ZEROCOPY is added for zero-copy buffer check.
> > 
> > Signed-off-by: Shirley Ma <xma@...ibm.com>
> 
> I was just reading this patch and noticed that you check if
> uarg->callback is set before calling it in skb_release_data, but you
> do
> not check before calling it in skb_copy_ubufs.
> 
> I was only skimming so I have probably missed something...

It is a redundant check. The userspace buffer info always has a callback
to release the buffers. I should have removed it after using tx_flags.

Thanks
Shirley

