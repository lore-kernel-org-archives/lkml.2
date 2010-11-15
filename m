Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881Ab0KOW7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:59:37 -0500
Received: from tundra.namei.org ([65.99.196.166]:57805 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933655Ab0KOW7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:59:34 -0500
Date: Tue, 16 Nov 2010 09:58:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: Eric Paris <eparis@parisplace.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
In-Reply-To: <1289860987.14282.40.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1011160953170.30359@tundra.namei.org>
References: <1289669176.16461.12.camel@Joe-Laptop>  <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>  <1289677904.16461.82.camel@Joe-Laptop>  <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>  <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
  <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com>  <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com>  <AANLkTikG=brgFP3yuWqMp=4ntHV=kyuhCUODZNp4Uo6Y@mail.gmail.com>  <alpine.LRH.2.00.1011160908380.29867@tundra.namei.org>
 <1289860987.14282.40.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Eric Paris wrote:

> Not sure how that's possible.  I mean, I guess it's possible if the
> fabled LSM reimplements the cap call, but I'm not sure how you can
> remove a restrictive only security check without 'weakening' the system
> in some way.

If generic security logic is mixed into a capability call, then not 
implementing the cap call also loses the generic security logic.

e.g. dmesg_restrict should always be verified, regardless of whether 
cap_security() is called or not.

If cap_syslog() should always be called, then it should not be possible 
not not call it :-)


- James
-- 
James Morris
<jmorris@namei.org>
