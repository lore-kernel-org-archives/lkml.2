Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0HCIVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:21:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55658
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab0HCIV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:21:27 -0400
Date: Tue, 03 Aug 2010 01:21:44 -0700 (PDT)
Message-Id: <20100803.012144.267950450.davem@davemloft.net>
To: andyc.bluearc@gmail.com
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, eric.dumazet@gmail.com,
        William.Allen.Simpson@gmail.com, gilad@codefidence.com,
        ilpo.jarvinen@helsinki.fi, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [Bug 16494] NFS client over TCP hangs due to packet
 loss
From: David Miller <davem@davemloft.net>
In-Reply-To: <4c57cfe8.887b0e0a.2f79.4772@mx.google.com>
References: <4c57cfe8.887b0e0a.2f79.4772@mx.google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Andy Chittenden" <andyc.bluearc@gmail.com>
Date: Tue, 3 Aug 2010 09:14:31 +0100

> I don't know whether this patch is the correct fix or not but it enables the
> NFS client to recover.
> 
> Kernel version: 2.6.34.1 and 2.6.32.
> 
> Fixes <https://bugzilla.kernel.org/show_bug.cgi?id=16494>. It clears down
> any previous shutdown attempts so that reconnects on a socket that's been
> shutdown leave the socket in a usable state (otherwise tcp_sendmsg() returns
> -EPIPE).

If the SunRPC code wants to close a TCP socket then use it again,
it should disconnect by doing a connect() with sa_family == AF_UNSPEC
