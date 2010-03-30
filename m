Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0C3U4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:56:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49353
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731Ab0C3U4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:56:21 -0400
Date: Tue, 30 Mar 2010 13:56:22 -0700 (PDT)
Message-Id: <20100330.135622.233398574.davem@davemloft.net>
To: steve@digidescorp.com
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
       linux-kernel@vger.kernel.org, monstr@monstr.eu, karl@hiramoto.org
Subject: Re: [PATCH] net: Fix oops from tcp_collapse() when using splice()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100330.134741.203608594.davem@davemloft.net>
References: <1269981913-18073-1-git-send-email-steve@digidescorp.com>
	<20100330.134741.203608594.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 30 Mar 2010 13:47:41 -0700 (PDT)

> From: "Steven J. Magnani" <steve@digidescorp.com>
> Date: Tue, 30 Mar 2010 15:45:13 -0500
> 
>> tcp_read_sock() can have a eat skbs without immediately advancing copied_seq.
>> This can cause a panic in tcp_collapse() if it is called as a result
>> of the recv_actor dropping the socket lock.
>> 
>> A userspace program that splices data from a socket to either another
>> socket or to a file can trigger this bug.
>> 
>> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> 
> Thanks for fixing this I'll look at your patch more closely
> right now.

Patch applied, thanks Steven!
