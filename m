Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab1C2AcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:32:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45137 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1C2AcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:32:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Mar 2011 09:25:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] forkbomb killer
Message-Id: <20110329092542.190fa31d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTi=BJrqsTTAuxz-ZDeioCZ=Sc6hbSw@mail.gmail.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110324105222.GA2625@barrios-desktop>
	<20110325090411.56c5e5b2.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=f3gu7-8uNiT4qz6s=BOhto5s=7g@mail.gmail.com>
	<20110325115453.82a9736d.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
	<20110326023452.GA8140@google.com>
	<AANLkTi=ng9vwoMJ=tseWwTsXMf9XZkMKUexcpEmQ45M_@mail.gmail.com>
	<BANLkTi=BJrqsTTAuxz-ZDeioCZ=Sc6hbSw@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 16:46:42 -0700
Michel Lespinasse <walken@google.com> wrote:

> On Sat, Mar 26, 2011 at 1:48 AM, Hiroyuki Kamezawa
> <kamezawa.hiroyuki@gmail.com> wrote:
> > 2011/3/26 Michel Lespinasse <walken@google.com>:
> >> I haven't heard of fork bombs being an issue for us (and it's not been
> >> for me on my desktop, either).
> >>
> >> Also, I want to point out that there is a classical userspace solution
> >> for this, as implemented by killall5 for example. One can do
> >> kill(-1, SIGSTOP) to stop all processes that they can send
> >> signals to (except for init and itself). Target processes
> >> can never catch or ignore the SIGSTOP. This stops the fork bomb
> >> from causing further damage. Then, one can look at the process
> >> tree and do whatever is appropriate - including killing by uid,
> >> by cgroup or whatever policies one wants to implement in userspace.
> >> Finally, the remaining processes can be restarted using SIGCONT.
> >>
> >
> > Can that solution work even under OOM situation without new login/commands ?
> > Please show us your solution, how to avoid Andrey's Bomb  with your way.
> > Then, we can add Documentation, at least. Or you can show us your tool.
> 
> To be clear, I don't have a full solution. I just think that the
> problem is approachable from userspace by freezing processes and then
> sorting them out. The killall5 utility is an example of that, though
> you would possibly want to add more smarts to it. If we want to
> include a kernel solution, I do like the simplicity of Minchan's
> proposal, too. But, I don't have a strong opinion on this matter, so
> feel free to ignore me if this is not useful feedback.
> 

I don't have strong opinion, too. I just think easily breakable kernel
by an user application is not ideal thing for me. To go to other buildings
to press reset-button is good for my health. I just implemnted a solution and
it seems to work well. Then, just want to ask how my patch looks.

But no one see patches, and it seems this feature is not welcome.
I'll continue to walk or just use virtual machines for testing OOM.

Thanks,
-Kame





