Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554Ab1LPSnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:43:52 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56970 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760393Ab1LPSni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:43:38 -0500
Date: Fri, 16 Dec 2011 13:42:47 -0500 (EST)
Message-Id: <20111216.134247.1388025459559232416.davem@davemloft.net>
To: decot@googlers.com
Cc: mcarlson@broadcom.com, mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martinez.javier@gmail.com,
        rgetz@blackfin.uclinux.org, mpm@selenic.com
Subject: Re: [PATCH net-next v1 0/6] tg3: adaptive interrupt coalescing,
 non-napi mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1324059527.git.decot@googlers.com>
References: <cover.1324059527.git.decot@googlers.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 16 Dec 2011 10:42:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>
Date: Fri, 16 Dec 2011 10:19:43 -0800

> This series implements adaptive interrupt coalescing for tg3 NIC,
> improving performance substancially. It also implements non-NAPI mode
> for specific system loads.

I specifically removed the dynamic IRQ coalescing from this driver years
ago.

It's too susceptible to state changes.

I am sure that you have some nice benchmark for which one scheme helps,
but more generally it is not possible to make it such that you will avoid
the case where the network flow pattern changes by the time you change
the chip configuration and thus the result is suboptimal.

I highly recommend these changes are not applied, because they will hurt
someone.
