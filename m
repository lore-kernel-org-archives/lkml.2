Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1KZVfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 16:35:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab1KZVfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 16:35:18 -0500
Date: Sat, 26 Nov 2011 16:35:15 -0500 (EST)
Message-Id: <20111126.163515.1110138680165158231.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: himeraster@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] AF_UNIX: Fix poll locking problem when reading
 from a stream socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321939381.27077.7.camel@edumazet-laptop>
References: <1321918525-5078-1-git-send-email-himeraster@gmail.com>
	<1321939381.27077.7.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 26 Nov 2011 13:35:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 22 Nov 2011 06:23:01 +0100

> Le mardi 22 novembre 2011 à 03:35 +0400, Alexey Moiseytsev a écrit :
>> poll() call may be locked by concurrent reading from the same stream
>> socket.
>> 
>> Signed-off-by: Alexey Moiseytsev <himeraster@gmail.com>
 ..
> Fine, the fix is technically correct since we own u->readlock mutex,
> another thread cannot consume the just requeued skb. 
> 
> Small note : the words "locking" and "locked" are more used to describe
> the action of taking a spinlock/mutex/rwlock or something, while the bug
> you fixed is more about poll() system call being blocked/frozen forever.
> 
> Thanks !
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, with 'lock{ing,ed}' adjusted to 'block{ing,ed}'.
