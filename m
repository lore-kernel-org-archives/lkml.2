Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab0KOXJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:09:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab0KOXJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:09:31 -0500
Subject: Re: [PATCH] Fix dmesg_restrict build failure with
 CONFIG_EMBEDDED=y and CONFIG_PRINTK=n
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1011160953170.30359@tundra.namei.org>
References: <1289669176.16461.12.camel@Joe-Laptop>
	 <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
	 <1289677904.16461.82.camel@Joe-Laptop>
	 <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
	 <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
	 <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com>
	 <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com>
	 <AANLkTikG=brgFP3yuWqMp=4ntHV=kyuhCUODZNp4Uo6Y@mail.gmail.com>
	 <alpine.LRH.2.00.1011160908380.29867@tundra.namei.org>
	 <1289860987.14282.40.camel@localhost.localdomain>
	 <alpine.LRH.2.00.1011160953170.30359@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 18:08:19 -0500
Message-ID: <1289862499.14282.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 09:58 +1100, James Morris wrote:
> On Mon, 15 Nov 2010, Eric Paris wrote:
> 
> > Not sure how that's possible.  I mean, I guess it's possible if the
> > fabled LSM reimplements the cap call, but I'm not sure how you can
> > remove a restrictive only security check without 'weakening' the system
> > in some way.
> 
> If generic security logic is mixed into a capability call, then not 
> implementing the cap call also loses the generic security logic.

I guess it comes down to what you define 'generic security logic.'
We've come to expect that capabilities are an indispensable mechanism
for control object access.  The prevalence of if (!capable(***))
throughout the kernel proves that fact.  I think that sometimes open
coding how we expect to use capabilities and sometimes hiding it behind
an LSM hook is just bad news.  I'd prefer all open coding, but that
might not be the best in all situations.  Hopefully I'll get a chance to
try to clean that up a little.

In any case, right now I need to go write a patch description since I
just compile tested it a couple of ways....

-Eric

