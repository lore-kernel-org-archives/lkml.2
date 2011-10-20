Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab1JTT5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 15:57:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58653 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab1JTT5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 15:57:33 -0400
Date: Thu, 20 Oct 2011 15:56:59 -0400 (EDT)
Message-Id: <20111020.155659.486754557434415381.davem@davemloft.net>
To: ari.m.savolainen@gmail.com
Cc: richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Kernel panic from tg3 net driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAEbykaX4UPDBxOHmNr=dodaquSPjhPr-pLCcUn5hSu4-xLZy-g@mail.gmail.com>
References: <CAEbykaXz+J8abVzU3yjqZG2+yhHNrQWsQy2c8wNyoERWPpxWKQ@mail.gmail.com>
	<CAEbykaX4UPDBxOHmNr=dodaquSPjhPr-pLCcUn5hSu4-xLZy-g@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 12:57:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ari Savolainen <ari.m.savolainen@gmail.com>
Date: Thu, 20 Oct 2011 22:30:44 +0300

> I finally got time to continue bisecting. The commit that causes the
> kernel panic is:  2669069aacc9 "tg3: enable transmit time stamping."

I thought initially that the issue might be that we have to do the
skb_tx_timestamp() call before we advance the mailbox transmit
descriptor pointer.

But that shouldn't matter, we run with a lock held, and TX reclaim takes
that same lock.

So I'm sort of stumped at the moment.

