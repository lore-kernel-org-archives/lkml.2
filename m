Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab0KSAtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:49:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347Ab0KSAtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:49:52 -0500
MIME-Version: 1.0
In-Reply-To: <20101119000204.GE6024@const.famille.thibault.fr>
References: <1289916171.5169.117.camel@maggy.simson.net> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
 <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net>
 <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net>
 <20101118234339.GA6024@const.famille.thibault.fr> <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com>
 <20101119000204.GE6024@const.famille.thibault.fr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 16:42:27 -0800
Message-ID: <AANLkTi=n4r9STKsx76t--HbK7EiUWaaPm7tUN2nXtqxA@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 4:02 PM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
>
>> If you're doing things per thread, you've already lost.
>
> Not per thread, per process, i.e. put threads of the same process in the
> same cgroup. Again, I would have thought that creating a cgroup is very
> lightweight in front of a fork()

Absolutely not.

We have a good light-weight fork(). We try to avoid any extra
allocations. We *definitely* don't want things at that level.

Seriously. I'd really like somebody running AIM7 just to see that even
just doing it at setsid() doesn't hurt too badly. And that's something
that happens once in a blue moon compared to fork and/or process
groups.

Once per session is about as much as is acceptable. That's the kind of
granularity we should look at. So things like "groups per user",
"groups per session", "groups per one graphical application" are good.
Not things that can happen tens of thousands of times a second.

                      Linus
