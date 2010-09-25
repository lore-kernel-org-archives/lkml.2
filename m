Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab0IYES0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 00:18:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33640
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932433Ab0IYESF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 00:18:05 -0400
Date: Fri, 24 Sep 2010 21:18:24 -0700 (PDT)
Message-Id: <20100924.211824.242130957.davem@davemloft.net>
To: padovan@profusion.mobi
Cc: netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        mathewm@codeaurora.org
Subject: Re: Deadlock in Bluetooth code in 2.6.36
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285104013-9946-1-git-send-email-padovan@profusion.mobi>
References: <1285104013-9946-1-git-send-email-padovan@profusion.mobi>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Gustavo F. Padovan" <padovan@profusion.mobi>
Date: Tue, 21 Sep 2010 18:20:12 -0300

> My questions here is on how to fix this properly. Maybe
> sock_alloc_send_skb() should not be used with SOCK_STREAM and reliable
> protocols and I'm not aware of that? And should I use something like
> sk_stream_alloc_skb() instead?
> 
> Any comments are welcome. With lucky we can fix that for 2.6.36 and
> together with others fixes we have queued deliver a fully functional
> L2CAP layer on 2.6.36.

Use sock_alloc_send_skb() as you do now, but if it fails wait for socket
space to become available just like TCP does, then loop back and try to
allocate again if the space-wait doesn't return an error.

I think you should be able to reuse sk_stream_wait_memory() for this
purpose just fine and without any problems.

