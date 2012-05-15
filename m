Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab2EORKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:10:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40225 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965109Ab2EORKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:10:01 -0400
Date: Tue, 15 May 2012 13:07:38 -0400 (EDT)
Message-Id: <20120515.130738.2194422199621090259.davem@davemloft.net>
To: arnd@arndb.de
Cc: geert@linux-m68k.org, jbohac@suse.cz, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3.4-rc7 regression] net/bond: return int from
 recv_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <201205151056.53621.arnd@arndb.de>
References: <20120512200901.811D37C0074@ra.kernel.org>
	<CAMuHMdVuDC7LiYuOdVELsxbbyf1PVZ-QvHY_7pUxigk+DWfysg@mail.gmail.com>
	<201205151056.53621.arnd@arndb.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 May 2012 10:07:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 15 May 2012 10:56:53 +0000

> 13a8e0c8c "bonding: don't increase rx_dropped after processing LACPDUs"
> changed the prototype of the bonding recv_probe handler, but only in
> some places, as identified by this warning:
> 
> drivers/net/bonding/bond_main.c: In function 'bond_handle_frame':
> drivers/net/bonding/bond_main.c:1463:13: error: assignment from incompatible pointer type [-Werror]
> drivers/net/bonding/bond_main.c: In function 'bond_open':
> drivers/net/bonding/bond_main.c:3441:21: error: assignment from incompatible pointer type [-Werror]
> drivers/net/bonding/bond_main.c:3448:20: error: assignment from incompatible pointer type [-Werror]
> 
> To fix this, we can change the remaining prototypes to return an
> integer as well, and always return RX_HANDLER_ANOTHER from rlb_arp_recv.

This has been fixed in Linus's tree for almost 2 days.
