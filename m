Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab0KOWwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:52:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016Ab0KOWwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:52:05 -0500
Subject: Re: A possible flaw in the fsnotify design.
From: Eric Paris <eparis@redhat.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>, linux-fsdevel@vger.kernel.org,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <AANLkTim9XWU-Qn5OT1J8H2j4kajMLL_GTQQ4_N296ueJ@mail.gmail.com>
References: <AANLkTimxbVnTVGobxhSTieJ4-PCTOZE_F6_E1-=8JcrO@mail.gmail.com>
	 <1289859078.14282.28.camel@localhost.localdomain>
	 <AANLkTim9XWU-Qn5OT1J8H2j4kajMLL_GTQQ4_N296ueJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 17:51:58 -0500
Message-ID: <1289861518.14282.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 01:44 +0300, Alexey Zaytsev wrote:
> On Tue, Nov 16, 2010 at 01:11, Eric Paris <eparis@redhat.com> wrote:
> > On Tue, 2010-11-16 at 01:05 +0300, Alexey Zaytsev wrote:
> >> Just some thoughts.
> >>
> >> Consider the situation: Files A and B both point to the same inode.
> >> File A is being watched, but the user won't get notifications if B is
> >> modified.
> >
> > That's not true.  Users watch inodes, not files (this is true for both
> > inotify and fanotify).  Give it a try, it works.
> >
> 
> debian-i386:~/tmp# touch a
> debian-i386:~/tmp# ../fanotify a &
> debian-i386:~/tmp# link a b
> debian-i386:~/tmp# ls -li
> total 0
> 3433 -rw-r--r-- 2 root root 0 Nov 15 22:37 a
> 3433 -rw-r--r-- 2 root root 0 Nov 15 22:37 b
> debian-i386:~/tmp# echo 123 > b
> /root/tmp/b: pid=2143 mask = 20 open
> /root/tmp/b: pid=2143 mask = a modify 0 - 4 close(writable)  0 - 4
> 
> Am I doing something wrong? Same thing happens if I watch the mount point.

Maybe I don't understand the problem, you watched the inode behind A.
You made changes accessing this inode via B, you got notification about
those changes.  Isn't that what you wanted?

