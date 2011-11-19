Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072Ab1KSFfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 00:35:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1KSFfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 00:35:31 -0500
Date: Sat, 19 Nov 2011 09:35:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
Message-ID: <20111119053526.GF21041@moon>
References: <4EC4DA15.7090106@parallels.com>
 <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com>
 <20111118110716.c854b4bd.akpm@linux-foundation.org>
 <20111118200342.GC21041@moon>
 <20111118123728.554b45e7.akpm@linux-foundation.org>
 <20111118210322.GD21041@moon>
 <20111118233840.GC6408@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118233840.GC6408@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 03:38:40PM -0800, Matt Helsley wrote:
...
> > 
> > Well, in case of hw-rng it should not be that easy, still of course
> > there is no 100% guarantee that there is absolutely no way to predict
> > this mask (espec since it's generated once at lives here forever). But
> 
> The random number itself could be of the best quality and the obfuscation
> could still be completely broken from a security standpoint. Put another
> way, we don't need to attack the method the random number was generated.
> We could probably utilize information we have about how the addresses
> themselves are generated.
> 

Agreed.

> > whatever makes attacker life harder -- is a good thing. After all we might
> > simply take some hash on kernel address here (such as sha256) since it's
> > not a time-critical operation and as far as I know collision is not found
> > for it yet (??).
> 
> Yes, cryptographic hashing seems much better than a highly suspect ad-hoc
> scheme which has barely been analyzed.
>

I'm surely fine with using crypto-hashes here.

> > 
> > > b) If we can export these addresses only to CAP_SYS_ADMIN tasks then
> > >    we don't need to obfuscate them anyway.
> > > 
> > >    Which takes me back to again asking: why not make c/r root-only?
> > >    And provide non-root access via a carefully-written setuid
> > >    front-end?
> > > 
> > 
> > I think non-root approach is a win in a long term (even if it requires
> 
> You could go with the root approach for now and make things more
> permissive later.
> 

Root-only makes all things easier, but I fear if we don't start with
non-root from the very beginning it'll remain root-only forever ;)

	Cyrill
