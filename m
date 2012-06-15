Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2FOIwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:52:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48191 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2FOIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:52:05 -0400
Subject: Re: [RFC] Introduce to batch variants of accept() and epoll_ctl()
 syscall
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Li Yu <raise.sail@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davidel@xmailserver.org
In-Reply-To: <4FDACA26.70004@gmail.com>
References: <4FDAB652.6070201@gmail.com>
	 <CABa6K_H3NrvvZ3Bh7JqsR6h33BSqYPBenUDG5Yt1U=2VvP700g@mail.gmail.com>
	 <4FDACA26.70004@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jun 2012 10:51:58 +0200
Message-ID: <1339750318.7491.70.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 13:37 +0800, Li Yu wrote:

> Of course, I think that implementing them should not be a hard work :)
> 
> Em. I really do not know whether it is necessary to introduce to a new 
> syscall here. An alternative solution to add new socket option to handle 
> such batch requirement, so applications also can detect if kernel has 
> this extended ability with a easy getsockopt() call.
> 
> Any way, I am going to try to write a prototype first.

Before that, could you post the result of "perf top", or "perf
record ...;perf report"

>  The top shows the kernel is most cpu hog, the testing is simple,
> just a accept() -> epoll_ctl(ADD) loop, the ratio of cpu util sys% to
> si% is about 2:5.

This ratio is not meaningful, if we dont know where time is spent.


I doubt epoll_ctl(ADD) is a problem here...

If it is, batching the fds wont speed the thing anyway...

I believe accept() is the problem here, because it contends with the
softirq processing the tcp session handshake.



