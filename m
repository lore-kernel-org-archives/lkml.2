Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2JFVRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 17:17:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38161 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2JFVRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 17:17:51 -0400
Date: Sat, 06 Oct 2012 17:17:48 -0400 (EDT)
Message-Id: <20121006.171748.734171045678392820.davem@davemloft.net>
To: haicheng.li@linux.intel.com
Cc: fengguang.wu@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net:master 1/9] pch_gbe_main.c:(.text+0x510370): undefined
 reference to `pch_ch_control_write'
From: David Miller <davem@davemloft.net>
In-Reply-To: <50706885.1030908@linux.intel.com>
References: <50703B1B.2040705@linux.intel.com>
	<20121006.102132.1497404004255213029.davem@davemloft.net>
	<50706885.1030908@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Sun, 07 Oct 2012 01:21:09 +0800

> Take IXGBE_PTP as example, it explicitly selects PPS, and also depends
> on EXPERIMENTAL:
> config IXGBE_PTP
>         bool "PTP Clock Support"
>         default n
>         depends on IXGBE && EXPERIMENTAL
>         select PPS
>         select PTP_1588_CLOCK
> 
> So if you stick to use "select" as the convention of such build issue
> fixing, fengguang's build failure would be fixed by:
> 	+ depends on EXPERIMENTAL
> 	+ select PPS
> 	+ select PTP_1588_CLOCK
> 
> would you prefer this way?

Yes, I would.

Thanks.
