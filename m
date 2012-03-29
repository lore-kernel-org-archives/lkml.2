Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab2C2IwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:52:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2C2IwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:52:05 -0400
Subject: Re: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=3A?= [PATCH] set fake_rtable's
 dst to NULL to avoid kernel Oops.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Peter Huang (Peng)" <peter.huangpeng@huawei.com>
Cc: linux-kernel@vger.kernel.org, harry.majun@huawei.com, zhoukang7@huawei.com,
        "'netdev'" <netdev@vger.kernel.org>
In-Reply-To: <002601cd0d76$c4987440$4dc95cc0$%huangpeng@huawei.com>
References: <002501cd0d74$317fd100$947f7300$%huangpeng@huawei.com>
	 <1333002975.2325.82.camel@edumazet-glaptop>
	 <002601cd0d76$c4987440$4dc95cc0$%huangpeng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Mar 2012 10:52:00 +0200
Message-ID: <1333011120.2325.354.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 14:40 +0800, Peter Huang (Peng) wrote:
> We already check current kernel-3.3, it has the same problem.
> 
> I am not very sure that if this modify could cause other problems or not,
> Because I don't know where fake_rtable was used.


Check net/bridge/br_netfilter.c and commits e688a6048076 (net: introduce
DST_NOPEER dst flag )  4adf0af6818f3ea5 (bridge: send correct MTU value
in PMTU (revised))

Apparently bug is because struct net_bridge is freed while its embedded
fake_rtable is still used by some packets.

I am not sure we are allowed to NULLify skb->dst, it might break
netfilter.

Maybe real fix would be to use a non embedded dst.



