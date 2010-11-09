Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0KIQ0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:26:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48452
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab0KIQ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:26:33 -0500
Date: Tue, 09 Nov 2010 08:26:56 -0800 (PST)
Message-Id: <20101109.082656.193719925.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: markus@trippelsdorf.de, paulmck@linux.vnet.ibm.com, miles.lane@gmail.com,
        ilpo.jarvinen@helsinki.fi, linux-kernel@vger.kernel.org,
        lenb@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] inet: fix ip_mc_drop_socket()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289250954.2790.11.camel@edumazet-laptop>
References: <1289249191.2790.3.camel@edumazet-laptop>
	<20101108205511.GB1585@arch.trippelsdorf.de>
	<1289250954.2790.11.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 08 Nov 2010 22:15:54 +0100

> Hmm, I believe I found the bug.
> 
> Thanks guys !
> 
> [PATCH] inet: fix ip_mc_drop_socket()
> 
> commit 8723e1b4ad9be4444 (inet: RCU changes in inetdev_by_index())
> forgot one call site in ip_mc_drop_socket()
> 
> We should not decrease idev refcount after inetdev_by_index() call,
> since refcount is not increased anymore.
> 
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks a lot!
