Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2BFQ4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:56:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40247 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2BFQ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:56:11 -0500
Message-ID: <1328547366.2220.83.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: steweg@ynet.sk, gregory.v.rose@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Mon, 06 Feb 2012 17:56:06 +0100
In-Reply-To: <20120206.101517.1598607878740481170.davem@davemloft.net>
References: <20120203.192933.510206531351047222.davem@davemloft.net>
	 <C5551D9AAB213A418B7FD5E4A6F30A0702F7F86F@ORSMSX106.amr.corp.intel.com>
	 <CAGsizzLFoXdUQrA-WtdRq4FDdnDNnevyK6HCRmrT2joUV=ZRXg@mail.gmail.com>
	 <20120206.101517.1598607878740481170.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 février 2012 à 10:15 -0500, David Miller a écrit :
> From: Štefan Gula <steweg@ynet.sk>
> Date: Mon, 6 Feb 2012 09:53:28 +0100
> 
> > If I try to request for it, it will eventually fail with a lot of
> > records even with filtering...
> 
> Then the user can loop increasing the buffer size until the netlink
> request succeeds.
> 
> It is not a problem.

Actually we always truncate message in netlink_recvmsg()

We could use a MSG_NOPARTIAL flag in netlink_recvmsg() so that user can
avoid the MSG_PEEK operation to fetch next message length.

(Ie not consume/copy skb if user buffer is too small to hold full
message, and only return the needed length)



