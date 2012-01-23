Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2AWT4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:56:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33852 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753010Ab2AWT4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:56:18 -0500
Message-ID: <1327348561.7527.0.camel@joe2Laptop>
Subject: Re: [PATCH/RESEND] drivers/net/ethernet: dev_alloc_skb to
 netdev_alloc_skb
From: Joe Perches <joe@perches.com>
To: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 23 Jan 2012 11:56:01 -0800
In-Reply-To: <CA+Dx6HY92Z8KtDXf73O3QMWLj__+Q2g7PxjiZ7omn+tuh8YK5A@mail.gmail.com>
References: <1327343283-4830-1-git-send-email-netdev@pradeepdalvi.com>
	 <1327344034.6317.3.camel@joe2Laptop>
	 <CA+Dx6HY92Z8KtDXf73O3QMWLj__+Q2g7PxjiZ7omn+tuh8YK5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 00:49 +0530, Pradeep A. Dalvi wrote:
> On Tue, Jan 24, 2012 at 12:10 AM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2012-01-23 at 23:58 +0530, Pradeep A. Dalvi wrote:
> >> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
> >>   - Removed extra skb->dev = dev after netdev_alloc_skb
> > []
> >> diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
> > []
> >> @@ -871,13 +871,12 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
> >>               struct sk_buff *skb;
> >>               void *rx_buff;
> >>
> >> -             skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
> >> +             skb = netdev_alloc_skb(dev, PKT_BUF_SZ);
> >
> > This change seems suspect.
> Not really sure what made you suspect something in here. If you could
> help me understand possibly broken scenarios, would essentially be
> helpful. Thanks in advance!

Where did the GFP_DMA go?


