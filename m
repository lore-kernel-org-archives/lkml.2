Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1AQRaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 12:30:06 -0500
Received: from mail.vyatta.com ([76.74.103.46]:50991 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1AQRaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 12:30:01 -0500
Date: Mon, 17 Jan 2011 09:29:59 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        "David S.Miller" <davem@davemloft.net>
Subject: Re: [PATCH] staging: fix build failure in bcm driver
Message-ID: <20110117092959.72b166af@nehalam>
In-Reply-To: <1295074306.3977.11.camel@edumazet-laptop>
References: <20110114172439.65d6d557@queued.net>
	<1295074306.3977.11.camel@edumazet-laptop>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Jan 2011 07:51:45 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le vendredi 14 janvier 2011 à 17:24 -0800, Andres Salomon a écrit :
> > While building, I hit the following:
> > 
> >   CC [M]  drivers/staging/bcm/Qos.o
> > drivers/staging/bcm/Qos.c: In function ‘PruneQueue’:
> > drivers/staging/bcm/Qos.c:367: error: ‘struct netdev_queue’ has no member named ‘tx_dropped’
> > drivers/staging/bcm/Qos.c: In function ‘flush_all_queues’:
> > drivers/staging/bcm/Qos.c:416: error: ‘struct netdev_queue’ has no member named ‘tx_dropped’
> > make[5]: *** [drivers/staging/bcm/Qos.o] Error 1
> > make[4]: *** [drivers/staging/bcm] Error 2
> > make[3]: *** [drivers/staging] Error 2
> > 
> > As well as:
> > 
> >   CC [M]  drivers/staging/bcm/Transmit.o
> > drivers/staging/bcm/Transmit.c: In function ‘SetupNextSend’:
> > drivers/staging/bcm/Transmit.c:163: error: ‘struct netdev_queue’ has no member named ‘tx_bytes’
> > drivers/staging/bcm/Transmit.c:164: error: ‘struct netdev_queue’ has no member named ‘tx_packets’
> > make[2]: *** [drivers/staging/bcm/Transmit.o] Error 1
> > 
> > 
> > tx_dropped/tx_bytes_tx_packets were removed in commit 1ac9ad13.  This patch
> > converts bcm to use net_device_stats instead of netdev_queue.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> BTW, chunks included in this patch have horrible codingstyle.
> 
> Is this driver planned for inclusion sometime ?
> 

Looks like the "remove dev_txq_stats_fold" patch missed the staging driver(s).

The bcm driver code is gross, the driver should be rewritten see the TODO.

Acked-by: Stephen Hemminger <shemminger@vyatta.com>
