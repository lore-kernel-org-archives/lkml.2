Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab0KSAAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:00:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757688Ab0KSAAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:00:04 -0500
MIME-Version: 1.0
In-Reply-To: <20101118234339.GA6024@const.famille.thibault.fr>
References: <1289916171.5169.117.camel@maggy.simson.net> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
 <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net>
 <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net>
 <20101118234339.GA6024@const.famille.thibault.fr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 15:51:35 -0800
Message-ID: <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
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

On Thu, Nov 18, 2010 at 3:43 PM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
>
> What overhead? The implementation of cgroups is actually already
> hierarchical.

Well, at least the actual group creation overhead.

If it's a "only at setsid()", that's a fairly rare thing (although I
think somebody might want to run something like the AIM7 benchmark - I
have this memory of it doing lots of tty tests).

Or if it's only at "user launches new program from window manager",
that's rare too.

But if you do it per process group, now you're doing one for each
command invocation in a shell, for example. If you're doing things per
thread, you've already lost.

Also, remember the goal: it was never about some theoretical end
result. It's all about a simple heuristic that makes things work
better. Trying to do that "perfectly" totally and utterly misses the
whole point.

(google "Perfect is the enemy of good" - Voltaire)

                      Linus
