Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2ITVuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:50:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39726 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2ITVuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:50:37 -0400
Date: Thu, 20 Sep 2012 17:50:34 -0400 (EDT)
Message-Id: <20120920.175034.401099732294832491.davem@davemloft.net>
To: avagin@openvz.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        xemul@parallels.com
Subject: Re: [PATCH] tcp: restore rcv_wscale in a repair mode (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348083600-3881500-1-git-send-email-avagin@openvz.org>
References: <1348083600-3881500-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>
Date: Wed, 19 Sep 2012 23:40:00 +0400

> rcv_wscale is a symetric parameter with snd_wscale.
> 
> Both this parameters are set on a connection handshake.
> 
> Without this value a remote window size can not be interpreted correctly,
> because a value from a packet should be shifted on rcv_wscale.
> 
> And one more thing is that wscale_ok should be set too.
> 
> This patch doesn't break a backward compatibility.
> If someone uses it in a old scheme, a rcv window
> will be restored with the same bug (rcv_wscale = 0).
> 
> v2: Save backward compatibility on big-endian system. Before
>     the first two bytes were snd_wscale and the second two bytes were
>     rcv_wscale. Now snd_wscale is opt_val & 0xFFFF and rcv_wscale >> 16.
>     This approach is independent on byte ordering.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> CC: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Applied, thanks.
