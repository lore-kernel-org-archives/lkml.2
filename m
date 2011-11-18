Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1KRVD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:03:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53102 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1KRVD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:03:28 -0500
Date: Sat, 19 Nov 2011 01:03:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
Message-ID: <20111118210322.GD21041@moon>
References: <4EC4DA15.7090106@parallels.com>
 <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com>
 <20111118110716.c854b4bd.akpm@linux-foundation.org>
 <20111118200342.GC21041@moon>
 <20111118123728.554b45e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118123728.554b45e7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 12:37:28PM -0800, Andrew Morton wrote:
...
> > 
> > Actually the address is not exposed in open-form but rather xor'ed with
> > a random number, still from security pov it's not clear if it's really useful
> > for attacker to obtain inverted low bits of the former random number (which
> > might happen on aligned addresses).
> > 
> 
> Of course.  But
> 
> a) I'm not sure that this scheme actually protects the kernel
>    addresses - there may be way in which cunning userspace can work out
>    the random mask.
> 

Well, in case of hw-rng it should not be that easy, still of course
there is no 100% guarantee that there is absolutely no way to predict
this mask (espec since it's generated once at lives here forever). But
whatever makes attacker life harder -- is a good thing. After all we might
simply take some hash on kernel address here (such as sha256) since it's
not a time-critical operation and as far as I know collision is not found
for it yet (??).

> b) If we can export these addresses only to CAP_SYS_ADMIN tasks then
>    we don't need to obfuscate them anyway.
> 
>    Which takes me back to again asking: why not make c/r root-only?
>    And provide non-root access via a carefully-written setuid
>    front-end?
> 

I think non-root approach is a win in a long term (even if it requires
some new CAP_ for that). The less root priviledge needed -- then better.
Having it root-only is easier of course and solves the problem of masking
kernel addresses from untrusted user-space agents, but still. Pavel, what
do you think about root-only?

	Cyrill
