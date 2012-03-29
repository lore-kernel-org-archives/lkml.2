Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab2C2JkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:40:18 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:49284 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2C2JkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:40:15 -0400
Date: Thu, 29 Mar 2012 17:38:59 +0800
From: "Peter Huang (Peng)" <peter.huangpeng@huawei.com>
Subject: =?utf-8?Q?=E7=AD=94=E5=A4=8D:_=E7=AD=94=E5=A4=8D:_=5BPATCH=5D_set_fake=5Fr?=
	=?utf-8?Q?table's_dst_to_NULL_to_avoid_ker?=	=?utf-8?Q?nel_Oops.?=
In-reply-to: <1333011120.2325.354.camel@edumazet-glaptop>
X-Originating-IP: [10.166.90.174]
To: "'Eric Dumazet'" <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, harry.majun@huawei.com, zhoukang7@huawei.com,
        "'netdev'" <netdev@vger.kernel.org>
Message-id: <004501cd0d8f$c4e133b0$4ea39b10$%huangpeng@huawei.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: zh-cn
Content-transfer-encoding: 7BIT
Thread-index: Ac0NiUAOi4y1MtRtQwOiaYy5PSejegABbjPg
X-CFilter-Loop: Reflected
References: <002501cd0d74$317fd100$947f7300$%huangpeng@huawei.com>
 <1333002975.2325.82.camel@edumazet-glaptop>
 <002601cd0d76$c4987440$4dc95cc0$%huangpeng@huawei.com>
 <1333011120.2325.354.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thks for your mail.

>Check net/bridge/br_netfilter.c and commits e688a6048076 (net: introduce
>DST_NOPEER dst flag )  4adf0af6818f3ea5 (bridge: send correct MTU value
>in PMTU (revised))

This patch already included in kernel-3.3, but for our case, virtual tap device's delayed
Deletion will also cause kernel oops even in kernel3.3.

>Apparently bug is because struct net_bridge is freed while its embedded
>fake_rtable is still used by some packets.

>I am not sure we are allowed to NULLify skb->dst, it might break
>netfilter.

Are you familiar with fake_rtable? I search the source, but only find one op that operate on the MTU.

>Maybe real fix would be to use a non embedded dst.

I agreed with you to, so at least until now this problem still exsits in the latest kernel, I will also look into it,
And try to modify it from the root.

Thanks again.



