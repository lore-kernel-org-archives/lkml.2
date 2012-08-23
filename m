Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab2HWEDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 00:03:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40925 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2HWEDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 00:03:19 -0400
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        John W Linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <50355021.7000408@lwfinger.net>
References: <50345B12.1050600@lwfinger.net>
	 <1345612503.5158.566.camel@edumazet-glaptop>
	 <50355021.7000408@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Aug 2012 06:03:13 +0200
Message-ID: <1345694593.5904.87.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 16:33 -0500, Larry Finger wrote:
> On 08/22/2012 12:15 AM, Eric Dumazet wrote:
> >
> > This particular commit is the start of a patches batch that ended in the
> > generic TCP coalescing mechanism.
> >
> > It is known to have problem on drivers doing skb_clone() in their rx
> > path.
> >
> > Current kernels should be ok, because coalescing doesnt happen if the
> > destination skb is cloned (skb_cloned(to) in skb_try_coalesce())
> 
> The skb_clone() call is not the source of the problem for r8712u, as it is only 
> used when a memory allocation fails, which is not happening. The suggestion did 
> lead to another patch that I had been preparing. The initial allocation of RX 
> buffers used a size of 30720 bytes, while 9100 is sufficient to allow 
> aggregation. Upon reducing the buffer size, the driver now works for me. I am 
> now awaiting tests by the OP on the Red Hat bugzilla before sending the patch 
> upstream.
> 
> So far, no ideas for the problem in connecting to WPA1 networks.
> 

Changing the allocation size removes the problem ? thats really strange.

If you try different sizes in the 9100-30720 range, can you pinpoint the
failure threshold ?



