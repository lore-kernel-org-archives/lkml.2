Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2LTVcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:32:20 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:48604 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab2LTVcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:32:11 -0500
Date: Thu, 20 Dec 2012 21:32:10 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andreas Voellmy <andreas.voellmy@yale.edu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "junchang.wang@yale.edu Wang" <junchang.wang@yale.edu>
Subject: Re: epoll with ONESHOT possibly fails to deliver events
Message-ID: <20121220213210.GA22655@dcvr.yhbt.net>
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu>
 <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu>
 <20121213093242.GA25436@dcvr.yhbt.net>
 <2F8919C4-395F-4029-8D4F-AD16A3815FC5@yale.edu>
 <9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9BE5F9A7-4D5B-4848-A0BA-55004240B6E0@yale.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Voellmy <andreas.voellmy@yale.edu> wrote:
> I wrote a C program that behaves similar to my original program and
> triggers the bug. The bug only arises when I use enough cores and
> threads (about 16). The program is here:
> https://github.com/AndreasVoellmy/epollbug/blob/master/epollbug.c

I finally took a closer look at your code.   I think your socketCheck()
thread is draining socket and causing the normal threads to miss
events.

Use the FIONREAD ioctl() instead to get unread bytes instead of recv().
If you want to recv() without draining the socket, you can also use
the MSG_PEEK flag.
