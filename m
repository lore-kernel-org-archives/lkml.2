Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab0KOWOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:14:04 -0500
Received: from tundra.namei.org ([65.99.196.166]:35647 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0KOWOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:14:02 -0500
Date: Tue, 16 Nov 2010 09:13:35 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@parisplace.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
In-Reply-To: <AANLkTikG=brgFP3yuWqMp=4ntHV=kyuhCUODZNp4Uo6Y@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1011160908380.29867@tundra.namei.org>
References: <1289669176.16461.12.camel@Joe-Laptop> <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com> <1289677904.16461.82.camel@Joe-Laptop> <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com> <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
 <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com> <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com> <AANLkTikG=brgFP3yuWqMp=4ntHV=kyuhCUODZNp4Uo6Y@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Eric Paris wrote:

> On Mon, Nov 15, 2010 at 12:41 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > If the old rule should have been that you _have_
> > to call cap_syslog(), then just eviscerating that entirely and putting
> > it in the generic code is definitely the right thing.
> 
> That is the rule for ALL of the hooks in commoncap.c.  The one time I
> tried to do something else *cough*mmap_min_addr*cough* I screwed it
> up.  I'll put a note in my todo list about looking into lifting all of
> commoncap.c into the callers.

If it's a requirement of the API that all of the cap calls are made 
first, then build it into the API, so developers can't make a mistake.  
e.g. have the LSM API do the secondary stacking of caps behind the scenes.

I had thought that the idea was that some LSM may want to not implement 
capabilities at all, on which case, it should still not be possible for 
the API to weaken the default security with or without caps.  In any case, 
mixing generic logic with capabilities logic seems to be a fundamental 
issue, and one which we should avoid, and remove where it may exist (I did 
audit the hooks after the mmap_min_addr thing, but it's worth checking 
again).


- James
-- 
James Morris
<jmorris@namei.org>
