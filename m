Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab1HWEH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 00:07:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44707 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1HWEHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 00:07:24 -0400
Date: Mon, 22 Aug 2011 21:02:55 -0700 (PDT)
Message-Id: <20110822.210255.1902105215409964106.davem@davemloft.net>
To: lacombar@gmail.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        mikey@neuling.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: boot test failure (net tree)
From: David Miller <davem@davemloft.net>
In-Reply-To: <CACqU3MW4BnucRt3gxPrKPDvWEjaVuxRF1VOPWk5hTRfneyANkg@mail.gmail.com>
References: <20110823114129.ceb18da164bf7df3c145941b@canb.auug.org.au>
	<20110822.191348.2099822249437201579.davem@davemloft.net>
	<CACqU3MW4BnucRt3gxPrKPDvWEjaVuxRF1VOPWk5hTRfneyANkg@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 22 Aug 2011 21:03:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaud Lacombe <lacombar@gmail.com>
Date: Mon, 22 Aug 2011 23:50:02 -0400

> Are you implying we need some kind of way to migrate config ?

The issue is that the dependencies for every single ethernet driver
have changed.  Some dependencies have been dropped (f.e. NETDEV_10000
and some have been added (f.e. ETHERNET, NET_VENDOR_****)

So right now an automated (non-prompted, default to no on all new
options) run on an existing config results in all ethernet drivers
getting disabled because the new dependencies don't get enabled.

This wouldn't be so bad if it was just one or two drivers, but in
this case it's every single ethernet driver which will have and hit
this problem.



