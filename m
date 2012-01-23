Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2AWVPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:15:50 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44709 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2AWVPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:15:48 -0500
Message-ID: <1327353339.2587.7.camel@edumazet-laptop>
Subject: Re: [PATCH/RESEND] drivers/net/ethernet: dev_alloc_skb to
 netdev_alloc_skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Cc: Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Date: Mon, 23 Jan 2012 22:15:39 +0100
In-Reply-To: <CA+Dx6HbxEFLTMMGJ-ASY=4zNthRtWps6KnFiPNLAz6o+HVmS9g@mail.gmail.com>
References: <1327343283-4830-1-git-send-email-netdev@pradeepdalvi.com>
	 <1327344034.6317.3.camel@joe2Laptop>
	 <CA+Dx6HY92Z8KtDXf73O3QMWLj__+Q2g7PxjiZ7omn+tuh8YK5A@mail.gmail.com>
	 <1327348561.7527.0.camel@joe2Laptop>
	 <CA+Dx6HbxEFLTMMGJ-ASY=4zNthRtWps6KnFiPNLAz6o+HVmS9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 02:11 +0530, Pradeep A. Dalvi a écrit :

> Aah! Is that really needed? Cause from my understanding, priority GFP
> flag __GFP_DMA is anyway negated in __alloc_skb, in a way from all
> sources i.e. netdev_alloc_skb or dev_alloc_skb or even alloc_skb. Am I
> missing something here?

You should read the whole __alloc_skb() function and not only half of
it.

skb itself is allocated in the normal memory pool, (not GFP_DMA), since
it has no hardware requirement for a kernel structure.

But skb->head _is_ allocated with GFP_DMA if driver requested it.



