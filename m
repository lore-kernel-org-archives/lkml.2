Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab0IXVls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:41:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42914
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753463Ab0IXVlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:41:47 -0400
Date: Fri, 24 Sep 2010 14:42:07 -0700 (PDT)
Message-Id: <20100924.144207.245411336.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nbowler@elliptictech.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ip : take care of last fragment in ip_append_data
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285049787.2323.797.camel@edumazet-laptop>
References: <1285013853.2323.148.camel@edumazet-laptop>
	<1285018272.2323.243.camel@edumazet-laptop>
	<1285049787.2323.797.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 21 Sep 2010 08:16:27 +0200

> [PATCH] ip : take care of last fragment in ip_append_data
> 
> While investigating a bit, I found ip_fragment() slow path was taken
> because ip_append_data() provides following layout for a send(MTU +
> N*(MTU - 20)) syscall :
> 
> - one skb with 1500 (mtu) bytes
> - N fragments of 1480 (mtu-20) bytes (before adding IP header)
> last fragment gets 17 bytes of trail data because of following bit:
> 
> 	if (datalen == length + fraggap)
> 		alloclen += rt->dst.trailer_len;
> 
> Then esp4 adds 16 bytes of data (while trailer_len is 17... hmm...
> another bug ?)
> 
> In ip_fragment(), we notice last fragment is too big (1496 + 20) > mtu,
> so we take slow path, building another skb chain.
> 
> In order to avoid taking slow path, we should correct ip_append_data()
> to make sure last fragment has real trail space, under mtu...
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
