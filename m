Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2GILu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:50:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42517 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2GILu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:50:57 -0400
Subject: Re: [PATCH] net: cgroup: fix out of bounds accesses
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        Gao feng <gaofeng@cn.fujitsu.com>
In-Reply-To: <20120709110154.GB9186@hmsreliant.think-freely.org>
References: <1341819910.3265.2106.camel@edumazet-glaptop>
	 <20120709110154.GB9186@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jul 2012 13:50:52 +0200
Message-ID: <1341834652.3265.2642.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 07:01 -0400, Neil Horman wrote:

> Thank you for doing this Eric, Gao.  Just to be sure (I asked in the previous
> thread), would it be better to avoid the length check in skb_update_prio, and
> instead update the netdev tables to be long enough in cgrp_create and in
> netprio_device_event on device registration?

Yes probably, and it is even needed because extend_netdev_table() can
acutally fail to expand the table if kzalloc() returned NULL.

Current code just ignores this allocation failure so we also can crash
in write_priomap()



