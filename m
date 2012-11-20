Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2KTSCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:02:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42104 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2KTSCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:02:04 -0500
Date: Tue, 20 Nov 2012 13:02:02 -0500 (EST)
Message-Id: <20121120.130202.1918742054229219388.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: paolo.valente@unimore.it, jhs@mojatatu.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121120095304.420ded7c@nehalam.linuxnetplumber.net>
References: <20121119.184828.628106002307042971.davem@davemloft.net>
	<50ABC19E.9030209@unimore.it>
	<20121120095304.420ded7c@nehalam.linuxnetplumber.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 20 Nov 2012 09:53:04 -0800

> There are actually lots of bogus warnings than seem to only occur
> because gcc 4.4 does a bad job of checking. Later versions are fixed
> and don't generate warnings.
> 
> My preference is to not add the unnecessary initialization because
> if you get in the habit of doing it. The whole purpose of the uninitialized
> check is lost. 

Try again, this was with gcc-4.7.2-2 on Fedora.

There are too many preconditions, across multiple basic block, which
together ensure the skb is in fact initialized at the point in
question and the compiler simply isn't sophisticated enough to see
that.
