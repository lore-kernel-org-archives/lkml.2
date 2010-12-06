Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0LFVBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 16:01:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57667
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758Ab0LFVBA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 16:01:00 -0500
Date: Mon, 06 Dec 2010 13:01:27 -0800 (PST)
Message-Id: <20101206.130127.179948200.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, tgraf@infradead.org
Subject: Re: [Patch] net: kill an RCU warning in inet_fill_link_af()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1291219386.2856.924.camel@edumazet-laptop>
References: <1291202063-6239-1-git-send-email-amwang@redhat.com>
	<1291219386.2856.924.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 01 Dec 2010 17:03:06 +0100

> Le mercredi 01 décembre 2010 à 19:14 +0800, Amerigo Wang a écrit :
>> From: WANG Cong <amwang@redhat.com>
>> 
>> The latest net-next-2.6 triggers an RCU warning during boot,
>> lockdep complains that in inet_fill_link_af() we call rcu_dereference_check()
>> without rcu_read_lock() protection.
>> 
>> This patch fixes it by replacing __in_dev_get_rcu() with in_dev_get().
> 
> Here is a better version, thanks a lot for your report and initial
> patch.
> 
> 
> [PATCH net-next-2.6] net: kill an RCU warning in inet_fill_link_af()
> 
> commits 9f0f7272 (ipv4: AF_INET link address family) and cf7afbfeb8c
> (rtnl: make link af-specific updates atomic) used incorrect
> __in_dev_get_rcu() in RTNL protected contexts, triggering PROVE_RCU
> warnings.
> 
> Switch to __in_dev_get_rtnl(), wich is more appropriate, since we hold
> RTNL.
> 
> Based on a report and initial patch from Amerigo Wang.
> 
> Reported-by: Amerigo Wang <amwang@redhat.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Thomas Graf <tgraf@infradead.org>

Applied.
