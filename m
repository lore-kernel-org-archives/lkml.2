Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab1CXWfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:35:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40918
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757267Ab1CXWfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:35:46 -0400
Date: Thu, 24 Mar 2011 15:36:23 -0700 (PDT)
Message-Id: <20110324.153623.45921344.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: alessandro.suardi@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: fix fib metrics
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301005946.2714.130.camel@edumazet-laptop>
References: <1301005107.2714.113.camel@edumazet-laptop>
	<AANLkTinv+XGBjbFoK6vpyiDW6gBEBKFjUef+mCAMJU9i@mail.gmail.com>
	<1301005946.2714.130.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 24 Mar 2011 23:32:26 +0100

> Then it doesnt work anymore because it parses an ipip field from
> ip route get ...
> 
> $ ip ro get 192.168.1.1
> 192.168.1.1 dev wlan0  src 192.168.1.21 
>     cache  ipid 0x784c mtu 1500 advmss 1460 hoplimit 64
> 
> 
> Maybe you upgraded iproute2

I'm leaning towards app bug too.

These default metrics wouldn't get printed before, but now because of
how metrics are handled, they will.

Userland needs to cope properly with this.
