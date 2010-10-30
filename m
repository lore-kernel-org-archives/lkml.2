Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0J3Viy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:38:54 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:44965 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0J3Viw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:38:52 -0400
Date: Sat, 30 Oct 2010 22:36:09 +0100
From: Alban Crequy <alban.crequy@collabora.co.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pauli Nieminen <pauli.nieminen@collabora.co.uk>,
        Rainer Weikusat <rweikusat@mssgmbh.com>
Subject: Re: [PATCH] af_unix: unix_write_space() use keyed wakeups
Message-ID: <20101030223609.2faa4eae@chocolatine.cbg.collabora.co.uk>
In-Reply-To: <1288421084.2680.717.camel@edumazet-laptop>
References: <20101029191857.5f789d56@chocolatine.cbg.collabora.co.uk>
	<1288380431.2680.3.camel@edumazet-laptop>
	<1288421084.2680.717.camel@edumazet-laptop>
Organization: Collabora
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sat, 30 Oct 2010 08:44:44 +0200,
Eric Dumazet <eric.dumazet@gmail.com> a écrit :

> We still loop on 800 items, on each wake_up_interruptible_sync_poll()
> call, so maybe we want to optimize this later, adding a global key,
> ORing all items keys. I dont think its worth the added complexity,
> given the biased usage of your program (800 'listeners' to one
> event). Is it a real life scenario ?

Pauli Nieminen told me about his performance problem in select() so I
wrote the test program but I don't know what exactly is the real life
scenario.

> [PATCH] af_unix: use keyed wakeups
> [PATCH] af_unix: optimize unix_dgram_poll()

Your 2 patches are good for me. In my opinion the improved performances
are good enough with your 2 patches, so no need to add more complexity
unless we discover new problems.

I am preparing patches to implement multicast features on Unix
datagram+seqpacket sockets and my patches could potentially make things
worse in unix_dgram_poll() because it would need to check the receiving
queues of all multicast members. So I want unix_dgram_poll() to be fast
in the first place before proposing other changes for multicast.
