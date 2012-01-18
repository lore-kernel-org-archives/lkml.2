Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2ARVmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:42:05 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40873 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2ARVmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:42:02 -0500
Date: Wed, 18 Jan 2012 16:41:45 -0500 (EST)
Message-Id: <20120118.164145.973182321372504360.davem@davemloft.net>
To: dvhart@linux.intel.com
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com,
        tomoya.rohm@gmail.com, jeffrey.t.kirsher@intel.com,
        paul.gortmaker@windriver.com, jdmason@kudzu.us, netdev@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, David.Laight@ACULAB.COM,
        joe@perches.com
Subject: Re: [PATCH] pch_gbe: Do not abort probe on bad MAC
From: David Miller <davem@davemloft.net>
In-Reply-To: <965df7d0c78e4971faf8464ec3da0bb114e9b5ee.1326743419.git.dvhart@linux.intel.com>
References: <965df7d0c78e4971faf8464ec3da0bb114e9b5ee.1326743419.git.dvhart@linux.intel.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 Jan 2012 13:41:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>
Date: Mon, 16 Jan 2012 11:50:19 -0800

> If the MAC is invalid or not implemented, do not abort the probe. Issue
> a warning and prevent bringing the interface up until a MAC is set manually
> (via ifconfig $IFACE hw ether $MAC).
> 
> Tested on two platforms, one with a valid MAC, the other without a MAC. The real
> MAC is used if present, the interface fails to come up until the MAC is set on
> the other. They successfully get an IP over DHCP and pass a simple ping and
> login over ssh test.
> 
> This is meant to allow the Inforce SYS940X development board:
> http://www.inforcecomputing.com/SYS940X_ECX.html
> (and others suffering from a missing MAC) to work with the mainline kernel.
> Without this patch, the probe will fail and the interface will not be created,
> preventing the user from configuring the MAC manually.
> 
> This does not make any attempt to address a missing or invalid MAC for the
> pch_phub driver.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>

Applied, thanks.
