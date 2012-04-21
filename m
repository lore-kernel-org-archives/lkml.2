Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2DUTe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 15:34:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43436 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2DUTez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 15:34:55 -0400
Date: Sat, 21 Apr 2012 15:34:40 -0400 (EDT)
Message-Id: <20120421.153440.1754750876890229323.davem@davemloft.net>
To: sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tj@kernel.org,
        ben-linux@fluff.org
Subject: Re: [PATCH 2/2] ks8851: Fix mutex deadlock in ks8851_net_stop()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334805958-29119-2-git-send-email-sboyd@codeaurora.org>
References: <1334805958-29119-1-git-send-email-sboyd@codeaurora.org>
	<1334805958-29119-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 21 Apr 2012 12:34:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Wed, 18 Apr 2012 20:25:58 -0700

> There is a potential deadlock scenario when the ks8851 driver
> is removed. The interrupt handler schedules a workqueue which
> acquires a mutex that ks8851_net_stop() also acquires before
> flushing the workqueue. Previously lockdep wouldn't be able
> to find this problem but now that it has the support we can
> trigger this lockdep warning by rmmoding the driver after
> an ifconfig up.
> 
> Fix the possible deadlock by disabling the interrupts in 
> the chip and then release the lock across the workqueue
> flushing. The mutex is only there to proect the registers
> anyway so this should be ok.
 ...
> Cc: Ben Dooks <ben-linux@fluff.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied.
