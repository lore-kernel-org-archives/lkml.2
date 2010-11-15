Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab0KOXMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:12:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab0KOXMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:12:47 -0500
Subject: Re: A possible flaw in the fsnotify design.
From: Eric Paris <eparis@redhat.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>, linux-fsdevel@vger.kernel.org,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        agruen@linbit.com
In-Reply-To: <AANLkTikAczyi0FQaSV4eVL5prdVbyZj6QCkPbf7cMW47@mail.gmail.com>
References: <AANLkTimxbVnTVGobxhSTieJ4-PCTOZE_F6_E1-=8JcrO@mail.gmail.com>
	 <1289859078.14282.28.camel@localhost.localdomain>
	 <AANLkTim9XWU-Qn5OT1J8H2j4kajMLL_GTQQ4_N296ueJ@mail.gmail.com>
	 <1289861518.14282.41.camel@localhost.localdomain>
	 <AANLkTikAczyi0FQaSV4eVL5prdVbyZj6QCkPbf7cMW47@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 18:12:34 -0500
Message-ID: <1289862754.14282.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 02:03 +0300, Alexey Zaytsev wrote:
> On Tue, Nov 16, 2010 at 01:51, Eric Paris <eparis@redhat.com> wrote:
> > On Tue, 2010-11-16 at 01:44 +0300, Alexey Zaytsev wrote:
> >> On Tue, Nov 16, 2010 at 01:11, Eric Paris <eparis@redhat.com> wrote:
> >> > On Tue, 2010-11-16 at 01:05 +0300, Alexey Zaytsev wrote:
> >> >> Just some thoughts.
> >> >>
> >> >> Consider the situation: Files A and B both point to the same inode.
> >> >> File A is being watched, but the user won't get notifications if B is
> >> >> modified.
> >> >
> >> > That's not true.  Users watch inodes, not files (this is true for both
> >> > inotify and fanotify).  Give it a try, it works.
> >> >
> >>
> >> debian-i386:~/tmp# touch a
> >> debian-i386:~/tmp# ../fanotify a &
> >> debian-i386:~/tmp# link a b
> >> debian-i386:~/tmp# ls -li
> >> total 0
> >> 3433 -rw-r--r-- 2 root root 0 Nov 15 22:37 a
> >> 3433 -rw-r--r-- 2 root root 0 Nov 15 22:37 b
> >> debian-i386:~/tmp# echo 123 > b
> >> /root/tmp/b: pid=2143 mask = 20 open
> >> /root/tmp/b: pid=2143 mask = a modify 0 - 4 close(writable)  0 - 4
> >>
> >> Am I doing something wrong? Same thing happens if I watch the mount point.
> >
> > Maybe I don't understand the problem, you watched the inode behind A.
> > You made changes accessing this inode via B, you got notification about
> > those changes.  Isn't that what you wanted?
> 
> I'd expect to get two notifications in this case. Might not be a
> problem when you are watching individual files, but there is no clear
> way to get all the modified files, if you are watching a mount point.

Ah, you were hoping for 4 events.  Yeah, not possible.  You get notified
when the inode changes, which way you get notified is up to the kernel
and we leave it as an (impossible) exercise to userspace to map hard
linked inodes back together   :)


