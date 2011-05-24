Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1EXRcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:32:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43564 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab1EXRcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:32:42 -0400
Date: Tue, 24 May 2011 13:28:25 -0400 (EDT)
Message-Id: <20110524.132825.968974982805294440.davem@davemloft.net>
To: vfalico@redhat.com
Cc: dlstevens@us.ibm.com, jmorris@namei.org, kaber@trash.net,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org, mmarek@suse.cz,
        netdev@vger.kernel.org, netdev-owner@vger.kernel.org,
        pekkas@netcore.fi, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH v4 1/1] igmp: call ip_mc_clear_src() only when we have
 no users of ip_mc_list
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110524091505.GA21550@darkmag.usersys.redhat.com>
References: <20110520162709.GA3497@darkmag.usersys.redhat.com>
	<OF8F2A5C61.8060D0CC-ON88257899.00610B06-88257899.006123E3@us.ibm.com>
	<20110524091505.GA21550@darkmag.usersys.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 May 2011 10:28:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Veaceslav Falico <vfalico@redhat.com>
Date: Tue, 24 May 2011 11:15:05 +0200

> In igmp_group_dropped() we call ip_mc_clear_src(), which resets the number
> of source filters per mulitcast. However, igmp_group_dropped() is also
> called on NETDEV_DOWN, NETDEV_PRE_TYPE_CHANGE and NETDEV_UNREGISTER, which
> means that the group might get added back on NETDEV_UP, NETDEV_REGISTER and
> NETDEV_POST_TYPE_CHANGE respectively, leaving us with broken source
> filters.
> 
> To fix that, we must clear the source filters only when there are no users
> in the ip_mc_list, i.e. in ip_mc_dec_group() and on device destroy.
> 
> Acked-by: David L Stevens <dlstevens@us.ibm.com>
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

Applied.
