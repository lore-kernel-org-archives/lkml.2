Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2JFNWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 09:22:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35957 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2JFNWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 09:22:11 -0400
Date: Sat, 06 Oct 2012 09:22:07 -0400 (EDT)
Message-Id: <20121006.092207.1280541690613202532.davem@davemloft.net>
To: haicheng.li@linux.intel.com
Cc: fengguang.wu@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net:master 1/9] pch_gbe_main.c:(.text+0x510370): undefined
 reference to `pch_ch_control_write'
From: David Miller <davem@davemloft.net>
In-Reply-To: <50701EEC.7080805@linux.intel.com>
References: <20121006075954.GA29618@localhost>
	<50701EEC.7080805@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Sat, 06 Oct 2012 20:07:08 +0800

> The failure is due to the CONFIG_PPS is not set there, consequently
> CONFIG_PTP_1588_CLOCK can not be set as =y anyway.
> 
> So David's patch of "da1586461e53a4dd045738cce309ab488970f0ef [1/9]
> pch_gbe: Fix PTP dependencies" is buggy. Furthermore, I think using
> "selects" to resolve such dependency issue is not good idea as it
> won't visit the dependencies.
> 
> David, I would still suggest to take my original patch:
> https://lkml.org/lkml/2012/9/28/70
> 
> + depends on PTP_1588_CLOCK_PCH && (PCH_GBE=m || PTP_1588_CLOCK_PCH=y)
> 
> or simply like:

This is all very rediculous if you ask me.

Why should the user have to know a detail like the underlying
PTP chip type just to enable PTP on his networking card?

Because that is what you are making him do with your change.

Select removed the necessity of the user having to know these
things.
