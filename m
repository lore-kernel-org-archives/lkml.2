Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1KMTdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 14:33:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab1KMTdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 14:33:31 -0500
Date: Sun, 13 Nov 2011 20:28:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
	pids
Message-ID: <20111113192848.GC4633@redhat.com>
References: <4EBCF4E7.4090002@parallels.com> <20111111152532.GA22640@redhat.com> <4EBD461E.1000106@parallels.com> <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com> <CAOS58YOS77+WZt19qu_72DPgEPdwTdkD88J6RNR4a3x0h-2Qkw@mail.gmail.com> <4EBD4ACB.2070001@parallels.com> <20111111162200.GA24737@google.com> <4EBD522E.2000203@parallels.com> <20111111170244.GB24737@google.com> <4EBD57D4.1060503@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD57D4.1060503@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Pavel Emelyanov wrote:
>
> Hm, so intrusiveness is your main concern here, I see.

To me, this is important.

> OK, let's assume we go with sysctl setting the last_pid.
>
> One of the major concerns with previous attempts have been - someone creates
> a process with a pid that was in use by some app recently and screws things
> up with pid reuse.

Good point.

> My approach solves this,

Yes. Although, can't resist, in a subtle way (imho). CLONE_CHILD_USEPIDS
stops working after a clone() without this flag.

> how can sysctl handle it? Allowing
> the last_pid change by the CAP_SYA_ADMIN

Yes, when I suggested set_last_pid I assumed that it needs CAP_SYS_ADMIN.

> only is not an option, since people
> are looking forward to non-root restore.

But CLONE_NEWPID needs CAP_SYS_ADMIN too ?

Anyway, I do not pretend I understand the problem space. And probably
it would be more convenient to change the creds before forking some
children with the predefined pids, I do not know.

So yes, I agree, CLONE_CHILD_USEPIDS wins here. Perhaps set_last_pid
needs another sysctl(set_last_pid_allowed)/whatever, or another idea.
Or we should use CLONE_CHILD_USEPIDS ;)

Let me repeat. It is not that I strongly against CLONE_CHILD_USEPIDS
(although yes, I can't say personally I like it very much ;). Just
I am trying to ensure we can't make something more clear/clean/simple,
at least from the kernel pov. Especially because you are trying to
establish the new user-visible API.

Oleg.

