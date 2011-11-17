Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1KQITE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:19:04 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58338 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1KQITA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:19:00 -0500
Message-ID: <1321517934.3274.44.camel@edumazet-laptop>
Subject: Re: [Bug] epoll_wait return EPOLLOUT even with EPOLLET flag
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Robin Dong <hao.bigrat@gmail.com>
Cc: linux-api@vger.kernel.org, linux-netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davidel@xmailserver.org
Date: Thu, 17 Nov 2011 09:18:54 +0100
In-Reply-To: <CAFZ0FUWptNqUJUkoj8=3eLSMrGKPKB5c7NcFv_5iJfJLuJF+sw@mail.gmail.com>
References: <CAFZ0FUWptNqUJUkoj8=3eLSMrGKPKB5c7NcFv_5iJfJLuJF+sw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 novembre 2011 à 16:07 +0800, Robin Dong a écrit :
> Hi,
> 
> I am a linux user and I found some question when using epoll with EPOLLET.
> 
> My program's step:
> 
> 1. create a socket (sfd) and connect to server
> 2. create epoll (efd)
> 3. add socket descriptor (sfd) to epoll (efd) with flag EPOLLET
> 4. get a EPOLLOUT event through epoll_wait
> 
> After that, the program will nerver get a EPOLLOUT event because ituse
> EPOLLET mode (the same event will not be got twice)
> 

Its not true. Same "status" can be delivered several time.

Think about Edge and Level trigger. An event (change of status) is the
trigger.

As soon as on trigger is done, epoll delivers a status.

And your file status is indeed EPOLLOUT | EPOLLIN, since you can read or
write on it.


> BUT，when a message comes from server，the client socket will get aevent
> and this event contains EPOLLOUT and EPOLLIN, looks epoll_waitreturn
> too much events than it should
> 
> My question is: Is this a bug for epoll ?

Not a bug, but a misinterpretation of what is an event and what is a
status.



