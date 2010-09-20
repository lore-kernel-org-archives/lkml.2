Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab0ITS4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:56:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16524 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab0ITS4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:56:18 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 20 Sep 2010 20:58:13 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] usb: gadget: rndis: don't use dev_get_stats()
In-reply-to: <20100920.112727.214208208.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        eric.dumazet@gmail.com
Message-id: <op.vjchnbf87p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <bdd595ff5a45c008254da0a0c4322b6e7b699cf2.1285006511.git.m.nazarewicz@samsung.com>
 <20100920.112727.214208208.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Michal Nazarewicz <m.nazarewicz@samsung.com>
>> This commit removes the call to dev_get_stats() from the
>> gen_ndis_query_resp() function.  Since spin_lock_bh() was
>> added to dev_txq_stats_fold() the call started causing
>> warnings.  This is because gen_ndis_query_resp() can be
>> (indirectly) called from rndis_command_complete() which is
>> called with interrupts disabled.

On Mon, 20 Sep 2010 20:27:27 +0200, David Miller <davem@davemloft.net> wrote:
> The way this works is dev_get_stats() takes that "temp" object the
> caller provides, it writes the correct statistics into it (with any
> necessary translations), and then passes back a pointer to it.
>
> See net/core/dev.c:dev_get_stats()
>
> You must use dev_get_stats() or else the statistics won't be properly
> converted.

I'm only wondering whether it's required for RNDIS to use dev_get_stats().
I haven't found reference to netdev_queue in g_ether related code and
I noticed that u_ether.c seems to update dev->stats directly.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
