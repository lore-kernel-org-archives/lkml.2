Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1CZIst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 04:48:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56730 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1CZIsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 04:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aCGlsObvQhmxTT1SBGbyVC/AtZ6ULc2amhJ9MqdCiGkOSUr8NZQceIEJrp2ZJjYQti
         b4HLD4shb4ePNco4GkFYbnluQd2kENcTh/c8FqSdzqfXDeAC6o6/A3whri1OSAWoacyK
         ytHHwyBorQ2FYc95+noISxAMLsUS0iruYX+PY=
MIME-Version: 1.0
In-Reply-To: <20110326023452.GA8140@google.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110324105222.GA2625@barrios-desktop>
	<20110325090411.56c5e5b2.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=f3gu7-8uNiT4qz6s=BOhto5s=7g@mail.gmail.com>
	<20110325115453.82a9736d.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
	<20110326023452.GA8140@google.com>
Date: Sat, 26 Mar 2011 17:48:45 +0900
Message-ID: <AANLkTi=ng9vwoMJ=tseWwTsXMf9XZkMKUexcpEmQ45M_@mail.gmail.com>
Subject: Re: [PATCH 0/4] forkbomb killer
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/26 Michel Lespinasse <walken@google.com>:
> On Fri, Mar 25, 2011 at 01:05:50PM +0900, Minchan Kim wrote:
>> Okay. Each approach has a pros and cons and at least, now anyone
>> doesn't provide any method and comments but I agree it is needed(ex,
>> careless and lazy admin could need it strongly). Let us wait a little
>> bit more. Maybe google guys or redhat/suse guys would have a opinion.
>
> I haven't heard of fork bombs being an issue for us (and it's not been
> for me on my desktop, either).
>
> Also, I want to point out that there is a classical userspace solution
> for this, as implemented by killall5 for example. One can do
> kill(-1, SIGSTOP) to stop all processes that they can send
> signals to (except for init and itself). Target processes
> can never catch or ignore the SIGSTOP. This stops the fork bomb
> from causing further damage. Then, one can look at the process
> tree and do whatever is appropriate - including killing by uid,
> by cgroup or whatever policies one wants to implement in userspace.
> Finally, the remaining processes can be restarted using SIGCONT.
>

Can that solution work even under OOM situation without new login/commands ?
Please show us your solution, how to avoid Andrey's Bomb  with your way.
Then, we can add Documentation, at least. Or you can show us your tool.

Maybe it is....
- running as a daemon. (because it has to lock its work memory before OOM.)
- mlockall its own memory to work under OOM.
- It can show process tree of users/admin or do all in automatic way
with user's policy.
- tell us which process is guilty.
- wakes up automatically when OOM happens.....IOW, OOM should have some notifier
  to userland.
- never allocate any memory at running. (maybe it can't use libc.)
- never be blocked by any locks, for example, some other task's mmap_sem.
  One of typical mistakes of admins at OOM is typing 'ps' to see what
happens.....
- Can be used even with GUI system, which can't show console.

Thanks,
-Kame
