Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2LTWdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:33:25 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49084 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2LTWdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:33:18 -0500
MIME-Version: 1.0
In-Reply-To: <20121220213210.GA22655@dcvr.yhbt.net>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu>
	<AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu>
	<20121213093242.GA25436@dcvr.yhbt.net>
	<2F8919C4-395F-4029-8D4F-AD16A3815FC5@yale.edu>
	<9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu>
	<20121220213210.GA22655@dcvr.yhbt.net>
Date: Thu, 20 Dec 2012 17:25:27 -0500
Message-ID: <CAErQho6bf+y+7dwtP4sKjNGsjLdDm8aBo4A6KagZHgcRT=KMWA@mail.gmail.com>
Subject: Re: epoll with ONESHOT possibly fails to deliver events
From: "Junchang(Jason) Wang" <junchang.wang@yale.edu>
To: Eric Wong <normalperson@yhbt.net>
Cc: Andreas Voellmy <andreas.voellmy@yale.edu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 4:32 PM, Eric Wong <normalperson@yhbt.net> wrote:
> Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
>> I wrote a C program that behaves similar to my original program and
>> triggers the bug. The bug only arises when I use enough cores and
>> threads (about 16). The program is here:
>> https://github.com/AndreasVoellmy/epollbug/blob/master/epollbug.c
>
> I finally took a closer look at your code.   I think your socketCheck()
> thread is draining socket and causing the normal threads to miss
> events.
>

Hi Wong,

Thank you so much for responses. But I think you probably
misunderstood socketCheck() which we use at the end of the program to
check whether the bug has occurred (by checking whether some data
remains in the sockets). Please note there's a sleep(10) (line 237) at
the very beginning of socketCheck(). In other words, we can guarantee
recv() (line 239) doesn't execute when the normal threads are running.

We still believe this is a bug in epoll system even though we can't
prove that so far. Both Andi and I are very interested in this problem
and helping you experts solve this it. Just let us know if we can
help.


Thanks.

> Use the FIONREAD ioctl() instead to get unread bytes instead of recv().
> If you want to recv() without draining the socket, you can also use
> the MSG_PEEK flag.
