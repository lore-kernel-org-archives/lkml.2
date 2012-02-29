Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030474Ab2B2SrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:47:11 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60297 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965939Ab2B2SrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:47:08 -0500
Date: Wed, 29 Feb 2012 13:46:56 -0500 (EST)
Message-Id: <20120229.134656.2184805638060629954.davem@davemloft.net>
To: mchan@broadcom.com
Cc: James.Bottomley@HansenPartnership.com, mcarlson@broadcom.com, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, florian@mickler.org,
        bhutchings@solarflare.com, netdev@vger.kernel.org
Subject: Re: [Bug #42707] Hang deconfiguring network interface (in
 shutdown) on 3.3-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330508017.7993.3.camel@HP1>
References: <20120228233225.GA1322@mcarlson.broadcom.com>
	<1330477116.2822.191.camel@dabdike.int.hansenpartnership.com>
	<1330508017.7993.3.camel@HP1>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 29 Feb 2012 10:46:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Wed, 29 Feb 2012 01:33:37 -0800

> Subject: [PATCH net] tg3: Fix tg3_get_stats64 for 5700 / 5701 devs
> 
> From: Matt Carlson <mcarlson@broadcom.com>
> 
> tg3_get_stats64() takes tp->lock when dealing with non-serdes bcm5700
> and bcm5701 devices.  However, functions that call tg3_halt() have
> already acquired tp->lock.  When tg3_get_stats64() is called in
> tg3_halt(), deadlock will occur.
> 
> This patch fixes the problem by separating the stat gathering code into
> a new tg3_get_nstats() function.  tg3_get_stats64() is recoded to call
> this function and take tp->lock.  The code that takes tp->lock in
> tg3_calc_crc_errors() has been removed.  Function signatures have been
> cleaned up too.
> 
> Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
> Signed-off-by: Michael Chan <mchan@broadcom.com>

Applied, thanks everyone.
