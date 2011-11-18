Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1KRXis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:38:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42444 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1KRXir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:38:47 -0500
Date: Fri, 18 Nov 2011 15:38:40 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
Message-ID: <20111118233840.GC6408@count0.beaverton.ibm.com>
References: <4EC4DA15.7090106@parallels.com>
 <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com>
 <20111118110716.c854b4bd.akpm@linux-foundation.org>
 <20111118200342.GC21041@moon>
 <20111118123728.554b45e7.akpm@linux-foundation.org>
 <20111118210322.GD21041@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118210322.GD21041@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11111823-1780-0000-0000-00000106E40C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000233; HX=3.00000178; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00088781; UDB=6.00023845; UTC=2011-11-18
 23:38:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 01:03:22AM +0400, Cyrill Gorcunov wrote:
> On Fri, Nov 18, 2011 at 12:37:28PM -0800, Andrew Morton wrote:
> ...
> > > 
> > > Actually the address is not exposed in open-form but rather xor'ed with
> > > a random number, still from security pov it's not clear if it's really useful
> > > for attacker to obtain inverted low bits of the former random number (which
> > > might happen on aligned addresses).
> > > 
> > 
> > Of course.  But
> > 
> > a) I'm not sure that this scheme actually protects the kernel
> >    addresses - there may be way in which cunning userspace can work out
> >    the random mask.
> > 
> 
> Well, in case of hw-rng it should not be that easy, still of course
> there is no 100% guarantee that there is absolutely no way to predict
> this mask (espec since it's generated once at lives here forever). But

The random number itself could be of the best quality and the obfuscation
could still be completely broken from a security standpoint. Put another
way, we don't need to attack the method the random number was generated.
We could probably utilize information we have about how the addresses
themselves are generated.

That said, this is pure speculation on my part. Getting someone with real
skill at attacking cryptographic systems to analyze the idea would be the
right way to go if you still want to pursue this scheme.

> whatever makes attacker life harder -- is a good thing. After all we might
> simply take some hash on kernel address here (such as sha256) since it's
> not a time-critical operation and as far as I know collision is not found
> for it yet (??).

Yes, cryptographic hashing seems much better than a highly suspect ad-hoc
scheme which has barely been analyzed.

> 
> > b) If we can export these addresses only to CAP_SYS_ADMIN tasks then
> >    we don't need to obfuscate them anyway.
> > 
> >    Which takes me back to again asking: why not make c/r root-only?
> >    And provide non-root access via a carefully-written setuid
> >    front-end?
> > 
> 
> I think non-root approach is a win in a long term (even if it requires

You could go with the root approach for now and make things more
permissive later.

Cheers,
	-Matt

