Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab0KOWoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:44:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57647 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224Ab0KOWoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:44:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AAc4sU7Z8qIgCFhX4t/Pd83Cjqnp3KGi8VfiW4YcJeVkmDcSoaMUq+XsuTB+tCFJjB
         ehgxjgtaIebX2BCFrI36Ek5S0j0INeKByRtViN0pSEgvXfFSVG3gD/9o+BiCSeOVSqRx
         j2T4NmBbIa+PlfJoIOuIT5a4FHC4+e1JrKZ/Y=
MIME-Version: 1.0
In-Reply-To: <1289859078.14282.28.camel@localhost.localdomain>
References: <AANLkTimxbVnTVGobxhSTieJ4-PCTOZE_F6_E1-=8JcrO@mail.gmail.com>
	<1289859078.14282.28.camel@localhost.localdomain>
Date: Tue, 16 Nov 2010 01:44:18 +0300
Message-ID: <AANLkTim9XWU-Qn5OT1J8H2j4kajMLL_GTQQ4_N296ueJ@mail.gmail.com>
Subject: Re: A possible flaw in the fsnotify design.
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>, linux-fsdevel@vger.kernel.org,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 01:11, Eric Paris <eparis@redhat.com> wrote:
> On Tue, 2010-11-16 at 01:05 +0300, Alexey Zaytsev wrote:
>> Just some thoughts.
>>
>> Consider the situation: Files A and B both point to the same inode.
>> File A is being watched, but the user won't get notifications if B is
>> modified.
>
> That's not true.  Users watch inodes, not files (this is true for both
> inotify and fanotify).  Give it a try, it works.
>

debian-i386:~/tmp# touch a
debian-i386:~/tmp# ../fanotify a &
debian-i386:~/tmp# link a b
debian-i386:~/tmp# ls -li
total 0
3433 -rw-r--r-- 2 root root 0 Nov 15 22:37 a
3433 -rw-r--r-- 2 root root 0 Nov 15 22:37 b
debian-i386:~/tmp# echo 123 > b
/root/tmp/b: pid=2143 mask = 20 open
/root/tmp/b: pid=2143 mask = a modify 0 - 4 close(writable)  0 - 4

Am I doing something wrong? Same thing happens if I watch the mount point.
