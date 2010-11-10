Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0KJUI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:08:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57372
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619Ab0KJUI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:08:56 -0500
Date: Wed, 10 Nov 2010 12:09:21 -0800 (PST)
Message-Id: <20101110.120921.246514765.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, jpirko@redhat.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 RESEND] net: packet: fix information leak to
 userland
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289413760-12510-1-git-send-email-segooon@gmail.com>
References: <1289413760-12510-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 10 Nov 2010 21:29:18 +0300

> packet_getname_spkt() doesn't initialize all members of sa_data field of
> sockaddr struct if strlen(dev->name) < 13.  This structure is then copied
> to userland.  It leads to leaking of contents of kernel stack memory.
> We have to fully fill sa_data with strncpy() instead of strlcpy().
> 
> The same with packet_getname(): it doesn't initialize sll_pkttype field of
> sockaddr_ll.  Set it to zero.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Applied.
