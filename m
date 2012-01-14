Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2ANIOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 03:14:42 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53773 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2ANIOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 03:14:41 -0500
Date: Sat, 14 Jan 2012 00:14:30 -0800 (PST)
Message-Id: <20120114.001430.787918662083526597.davem@davemloft.net>
To: dvhart@linux.intel.com
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com,
        tomoya.rohm@gmail.com, jeffrey.t.kirsher@intel.com,
        paul.gortmaker@windriver.com, jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of
 failing probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com>
References: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 14 Jan 2012 00:14:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>
Date: Fri, 13 Jan 2012 22:44:55 -0800

> If the MAC is invalid or not implemented, use a randomly generated one rather
> than failing the probe. Store the generated addr in a new sw_mac array in the
> pch_gbe_mac_info structure. Take care to allow for assigning the MAC via
> ifconfig by reusing sw_addr to store an assigned mac if probe populated it with
> a random one (otherwise the assignment would rely on the ROM and the reset would
> fail to write a valid MAC to the rx filter).
> 
> Tested on two platforms, one with a valid MAC, the other without a MAC. The
> real MAC is used if present, a randomly generated one otherwise. Both are
> capable of changing the MAC with ifconfig. They successfully get an IP over
> DHCP and pass a simple ping and login over ssh test.
> 
> This does not make any attempt to address a missing or invalid MAC for the
> pch_phub driver.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>

I don't want to see code like this added if it's "just in case."

Please correct any hardware that hasn't shipped yet or is alpha/beta
hardware in testing, so that we don't need stuff like this.
