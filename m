Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2DXESv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 00:18:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35190 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab2DXESu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 00:18:50 -0400
Date: Tue, 24 Apr 2012 00:17:35 -0400 (EDT)
Message-Id: <20120424.001735.1975136616657606100.davem@davemloft.net>
To: peter.huangpeng@huawei.com
Cc: shemminger@vyatta.com, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        peter.huangpeng@gmail.com, linux-kernel@vger.kernel.org,
        harry.majun@huawei.com, ctrix+debianbugs@navynet.it
Subject: Re: [PATCH v4] set fake_rtable's dst to NULL to avoid kernel Oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F90FE63.9060800@huawei.com>
References: <4F90FE63.9060800@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Apr 2012 21:17:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Peter Huang(Peng)" <peter.huangpeng@huawei.com>
Date: Fri, 20 Apr 2012 14:12:51 +0800

> bridge: set fake_rtable's dst to NULL to avoid kernel Oops
> 
> when bridge is deleted before tap/vif device's delete, kernel may
> encounter an oops because of NULL reference to fake_rtable's dst.
> Set fake_rtable's dst to NULL before sending packets out can solve
> this problem.
> 
> v4 reformat, change br_drop_fake_rtable(skb) to {}
> 
> v3 enrich commit header
> 
> v2 introducing new flag DST_FAKE_RTABLE to dst_entry struct.
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Peter Huang <peter.huangpeng@huawei.com>

Applied, although I changed to nop br_drop_fake_rtable() implementation
to use "do { } while (0)" instead of just plain "{ }".
