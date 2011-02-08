Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1BHHvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 02:51:33 -0500
Received: from mailout09.t-online.de ([194.25.134.84]:44810 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab1BHHvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 02:51:31 -0500
Message-ID: <4D50F5FA.7050202@t-online.de>
Date: Tue, 08 Feb 2011 08:51:22 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        mostrows@earthlink.net, linux-ppp@vger.kernel.org, xiaosuo@gmail.com,
        eric.dumazet@gmail.com
Subject: Re: [BUG] 2.6.38-rc2: Circular Locking Dependency
References: <4D3D45A3.7040809@t-online.de> <20110206.232856.246531984.davem@davemloft.net> <20110207102950.GA17044@brick.ozlabs.ibm.com> <20110207104315.GB17044@brick.ozlabs.ibm.com>
In-Reply-To: <20110207104315.GB17044@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: TQ1B-rZOrh5xACPhR6VCRIRt1Q4OOOv1Yw+9iMfZpSulWH1SDQF0rVZWc16SksyQPn
X-TOI-MSGID: 6c657531-0135-4819-997c-3f1284e45023
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody!

I bisected the problem with the following result:

aa9421041128abb4d269ee1dc502ff65fb3b7d69 is the first bad commit
commit aa9421041128abb4d269ee1dc502ff65fb3b7d69
Author: Changli Gao <xiaosuo@gmail.com>
Date:   Sat Dec 4 02:31:41 2010 +0000

    net: init ingress queue

    The dev field of ingress queue is forgot to initialized, then NULL
    pointer dereference happens in qdisc_alloc().

    Move inits of tx queues to netif_alloc_netdev_queues().

    Signed-off-by: Changli Gao <xiaosuo@gmail.com>
    Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 dcbb6ab41c4308cba1bc6823d200dcf92aa402d8
b5e190ec681d26ffe62d1d0214c4ef77b8034189 M      net

cu,
 Knut
