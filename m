Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1KNFjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:39:25 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52856 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1KNFjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:39:24 -0500
Date: Mon, 14 Nov 2011 00:39:19 -0500 (EST)
Message-Id: <20111114.003919.1393266325552023244.davem@davemloft.net>
To: avagin@openvz.org
Cc: shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] bridge: Fix potential deadlock on br->multicast_lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320940083-3719823-1-git-send-email-avagin@openvz.org>
References: <1320940083-3719823-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:39:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>
Date: Thu, 10 Nov 2011 18:48:03 +0300

> multicast_lock is taken in softirq context, so we should use
> spin_lock_bh() in userspace.
> 
> call-chain in softirq context:
> run_timer_softirq()
> 	br_multicast_query_expired()
> 
> call-chain in userspace:
> sysfs_write_file()
> 	store_multicast_snooping()
> 		br_multicast_toggle()
> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Applied, thanks.
