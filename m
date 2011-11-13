Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1KMTDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 14:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1KMTDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 14:03:46 -0500
Date: Sun, 13 Nov 2011 19:59:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
	pids
Message-ID: <20111113185902.GB4633@redhat.com>
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com> <20111110184654.GA1006@redhat.com> <20111110185603.GA1757@redhat.com> <4EBCF4E7.4090002@parallels.com> <20111111152532.GA22640@redhat.com> <4EBD461E.1000106@parallels.com> <20111111163926.GA25106@redhat.com> <4EBD5391.2070802@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD5391.2070802@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Pavel Emelyanov wrote:
>
> > Yes, sysctl+clone should be "atomic", but that is all. Does it really
> > hurt? OK, if nothing else, can't you do somthing like
> ...
> Nope, as I said to Tejun, we will most likely not forks children in the depth-first
> order,

But this doesn't matter. I think you misunderstood a bit. You can do
set_last_pid+clone at any time. It doesn't depen on previous clone's.
Unless, of course, the necessary pid_nr was already used, but this is
equally true for CLONE_CHILD_USEPIDS.

> But I don't insist.

You should ;)

> If the CLONE_CHILD_USEPIDS has absolutely no way in the kernel we'll
> have to go the uglier path.

All I think is: we should discuss everything we can before we add the
new API. Probably we need a wider CC.

Yes, personally I can't say I like CLONE_CHILD_USEPIDS very much. But
I agree that sysctl(set_last_pid) (or whatever) is not perfect too.
To me, it has only one but very important (imho) advantage: it is much
simpler and understandable.

Oleg.

