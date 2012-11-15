Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab2KOWpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:45:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49094 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2KOWps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:45:48 -0500
Date: Thu, 15 Nov 2012 17:45:46 -0500 (EST)
Message-Id: <20121115.174546.336072708541078221.davem@davemloft.net>
To: xemul@parallels.com
Cc: avagin@openvz.org, netdev@vger.kernel.org, criu@openvz.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] tcp: fix retransmission in repair mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <50A4F7F3.5080500@parallels.com>
References: <1352988197-14414-1-git-send-email-avagin@openvz.org>
	<50A4F7F3.5080500@parallels.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@parallels.com>
Date: Thu, 15 Nov 2012 18:10:59 +0400

> On 11/15/2012 06:03 PM, Andrey Vagin wrote:
>> From: Andrew Vagin <avagin@openvz.org>
>> 
>> Currently if a socket was repaired with a few packet in a write queue,
>> a kernel bug may be triggered:
>> 
>> kernel BUG at net/ipv4/tcp_output.c:2330!
>> RIP: 0010:[<ffffffff8155784f>] tcp_retransmit_skb+0x5ff/0x610
>> 
>> According to the initial realization v3.4-rc2-963-gc0e88ff,
>> all skb-s should look like already posted. This patch fixes code
>> according with this sentence.
>> 
>> Here are three points, which were not done in the initial patch:
>> 1. A tcp send head should not be changed
>> 2. Initialize TSO state of a skb
>> 3. Reset the retransmission time
>> 
>> This patch moves logic from tcp_sendmsg to tcp_write_xmit. A packet
>> passes the ussual way, but isn't sent to network. This patch solves
>> all described problems and handles tcp_sendpages.
 ...
>> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> 
> Acked-by: Pavel Emelyanov <xemul@parallels.com>

Applied and queued up for -stable, thanks.
