Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab1FJWWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:22:25 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27684 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1FJWWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:22:23 -0400
Date: Sat, 11 Jun 2011 00:14:02 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Why is CONFIG_FHANDLE an option??
Message-ID: <alpine.LNX.2.00.1106110001180.21722@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I just configured a new kernel based on a recent git checkout and when I 
had copied in my old configuration and did a "make oldconfig"I was greeted 
with

    open by fhandle syscalls (FHANDLE) [N/y/?] (NEW)

Ok, so I read the help text description and learn that it's about two new 
syscalls - open_by_handle_at(2) and name_to_handle_at(2).

My first thought at this point was "why are new syscalls even an option"?

Syscalls are in my oppinion ABI - having optional syscalls is just about 
as bad as removing a syscall. It basically means that users cannot know if 
the syscall is there and will need to test (it's bad enough having to 
check the kernel version, having to check for specific syscalls as well 
is just, well, annoying at best). 

Why are we making these optional?
I'd say we should just add them unconditionally or not have them at all. 
One should be able to say that "since Linux 3.0 these syscalls are 
available", not "since Linux 3.0 these syscalls *may* be available"... 
We'll just end up in a situation where some distributors enable the 
syscalls, some don't and it'll all be a mess for users... either we have 
them or we don't.

Ok, long rant, sorry about that... but really; why are they optional??


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

