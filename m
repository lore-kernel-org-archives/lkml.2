Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab0KOWob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:44:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758716Ab0KOWoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:44:30 -0500
Subject: Re: [PATCH] Fix dmesg_restrict build failure with
 CONFIG_EMBEDDED=y and CONFIG_PRINTK=n
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1011160908380.29867@tundra.namei.org>
References: <1289669176.16461.12.camel@Joe-Laptop>
	 <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
	 <1289677904.16461.82.camel@Joe-Laptop>
	 <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
	 <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
	 <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com>
	 <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com>
	 <AANLkTikG=brgFP3yuWqMp=4ntHV=kyuhCUODZNp4Uo6Y@mail.gmail.com>
	 <alpine.LRH.2.00.1011160908380.29867@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 17:43:07 -0500
Message-ID: <1289860987.14282.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 09:13 +1100, James Morris wrote:
> On Mon, 15 Nov 2010, Eric Paris wrote:
> 
> > On Mon, Nov 15, 2010 at 12:41 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > If the old rule should have been that you _have_
> > > to call cap_syslog(), then just eviscerating that entirely and putting
> > > it in the generic code is definitely the right thing.
> > 
> > That is the rule for ALL of the hooks in commoncap.c.  The one time I
> > tried to do something else *cough*mmap_min_addr*cough* I screwed it
> > up.  I'll put a note in my todo list about looking into lifting all of
> > commoncap.c into the callers.
> 
> If it's a requirement of the API that all of the cap calls are made 
> first, then build it into the API, so developers can't make a mistake.  
> e.g. have the LSM API do the secondary stacking of caps behind the scenes.

At this point it's a defacto requirement since noone is doing anything
like that.  My mmap_min_addr screw up is, to the best of my knowledge,
the only time anyone has intentionally not called the caps code...

And I sorta like the idea of moving the cap_* calls directly into
security_*.  Great, another item on the todo list.  Lift as many cap
calls into the caller as is reasonable (I don't think there are
many/any) and if not possible lift them directory into security_*.  If
someone else really wants to make a system truely without capabilities
lets look at there solution then....

> I had thought that the idea was that some LSM may want to not implement 
> capabilities at all, on which case, it should still not be possible for 
> the API to weaken the default security with or without caps.

Not sure how that's possible.  I mean, I guess it's possible if the
fabled LSM reimplements the cap call, but I'm not sure how you can
remove a restrictive only security check without 'weakening' the system
in some way.

