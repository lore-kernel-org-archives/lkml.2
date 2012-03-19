Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2CSV1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:27:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39338 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2CSV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:27:22 -0400
Date: Mon, 19 Mar 2012 17:27:17 -0400 (EDT)
Message-Id: <20120319.172717.567266094785758733.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: haiyangz@microsoft.com, kys@microsoft.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH v2,1/1] net/hyperv: Fix the code handling tx busy
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332192191.9397.62.camel@edumazet-glaptop>
References: <1332192233-32305-1-git-send-email-haiyangz@microsoft.com>
	<1332192233-32305-2-git-send-email-haiyangz@microsoft.com>
	<1332192191.9397.62.camel@edumazet-glaptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 14:27:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 19 Mar 2012 14:23:11 -0700

> On Mon, 2012-03-19 at 14:23 -0700, Haiyang Zhang wrote:
>> Instead of dropping the packet, we keep the skb buffer, and return
>> NETDEV_TX_BUSY to let upper layer retry send. This will not cause
>> endless loop, because the host is taking data away from ring buffer,
>> and we have called the stop_queue before returning NETDEV_TX_BUSY.
>> 
>> The stop_queue was called in the function netvsc_send() in file 
>> netvsc.c, then it returns to rndis_filter_send(), which returns to
>> netvsc_start_xmit() in file netvsc_drv.c. So the NETDEV_TX_BUSY is
>> indeed returned AFTER queue is stopped.
>> 
>> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
>> ---
> 
> Thanks 
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
