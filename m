Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab1KVUPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:15:38 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53366 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab1KVUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:15:36 -0500
Date: Tue, 22 Nov 2011 15:14:29 -0500 (EST)
Message-Id: <20111122.151429.253381379981773726.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-11-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111122193505.GC8452@tuxdriver.com>
References: <20111122193505.GC8452@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 Nov 2011 12:14:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 22 Nov 2011 14:35:05 -0500

> Here is the latest batch of fixes intended for 3.2.  This includes a
> correction for a user-visible error in mac80211's debugfs info, a fix
> for a potential memory corrupter in prism54, an endian fix for rt2x00,
> an endian fix for mac80211, a fix for a NULL derefernce in cfg80211, a
> locking fix and a deadlock fix for p54spi, and a pair of rt2x00 fixes
> for handling some spurious interrupts that hardware can generate.
> 
> Please let me know if there are problems!

The rt2800pci change doesn't look correct.

If the IRQ line is shared with another device, this change will make it
never see interrupts.  Once you say "IRQ_HANDLED" the IRQ dispatch
stops processing the interrupt handler list.
