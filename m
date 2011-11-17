Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1KQIH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:07:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60940 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab1KQIH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:07:58 -0500
MIME-Version: 1.0
Date: Thu, 17 Nov 2011 16:07:56 +0800
Message-ID: <CAFZ0FUWptNqUJUkoj8=3eLSMrGKPKB5c7NcFv_5iJfJLuJF+sw@mail.gmail.com>
Subject: [Bug] epoll_wait return EPOLLOUT even with EPOLLET flag
From: Robin Dong <hao.bigrat@gmail.com>
To: linux-api@vger.kernel.org, linux-netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: davidel@xmailserver.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am a linux user and I found some question when using epoll with EPOLLET.

My program's step:

1. create a socket (sfd) and connect to server
2. create epoll (efd)
3. add socket descriptor (sfd) to epoll (efd) with flag EPOLLET
4. get a EPOLLOUT event through epoll_wait

After that, the program will nerver get a EPOLLOUT event because ituse
EPOLLET mode (the same event will not be got twice)

BUT£¬when a message comes from server£¬the client socket will get aevent
and this event contains EPOLLOUT and EPOLLIN, looks epoll_waitreturn
too much events than it should

My question is: Is this a bug for epoll ?

Any reply will be appreciate.

--
--
Best Regard
Robin Dong
