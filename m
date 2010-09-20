Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0ITRqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:46:54 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62895 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab0ITRqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:46:52 -0400
Date: Mon, 20 Sep 2010 19:48:47 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] net: core: dev.c: use spin_lock_irqsave() rather than
In-reply-to: <1284998621.3420.539.camel@edumazet-laptop>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Message-id: <op.vjceflc37p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <ee14e5e38e7a5df520d902ef8a236bbe9ed206fa.1284991149.git.m.nazarewicz@samsung.com>
 <1284998621.3420.539.camel@edumazet-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 18:03:41 +0200, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> dev_get_stats(dev, &temp) is called from drivers/usb/gadget/rndis.c,
> while I suspect underlying stats are already provided in dev->stats

So, you are saying that it is likely that if I change rndis.c and replace
"dev_get_stats(net, &temp)" with plain "&net->stats" things should work
correctly (rndis.c does not use the "temp" so it's not a problem)?

I actually did that and nothing seems to crash but dunno if it didn't
make g_ether report some not fully up-to-date values or something.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
