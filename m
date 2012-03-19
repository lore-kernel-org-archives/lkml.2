Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2CSVXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:23:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38273 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab2CSVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:23:14 -0400
Subject: Re: [PATCH v2,1/1] net/hyperv: Fix the code handling tx busy
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: kys@microsoft.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
In-Reply-To: <1332192233-32305-2-git-send-email-haiyangz@microsoft.com>
References: <1332192233-32305-1-git-send-email-haiyangz@microsoft.com>
	 <1332192233-32305-2-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 14:23:11 -0700
Message-ID: <1332192191.9397.62.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 14:23 -0700, Haiyang Zhang wrote:
> Instead of dropping the packet, we keep the skb buffer, and return
> NETDEV_TX_BUSY to let upper layer retry send. This will not cause
> endless loop, because the host is taking data away from ring buffer,
> and we have called the stop_queue before returning NETDEV_TX_BUSY.
> 
> The stop_queue was called in the function netvsc_send() in file 
> netvsc.c, then it returns to rndis_filter_send(), which returns to
> netvsc_start_xmit() in file netvsc_drv.c. So the NETDEV_TX_BUSY is
> indeed returned AFTER queue is stopped.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---

Thanks 

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


