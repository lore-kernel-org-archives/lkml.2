Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1BPQXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:23:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36884 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1BPQXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:23:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nbfqq88Da1Dq53sKhQLngazAZpEs1m+7tEXvnNbTynAta1uzInmNpaZ212Ze0tJt5f
         CJEYkKI9bBb1PfvQfAW5wGQ4tXR1AbZRZEhEUceKpwdaAXnrzuakfP9pVy6Qim2zvo2i
         McG33C7fSBpadfBhB/gv4wWgLsE3o0Kz1H/8o=
Subject: Re: Linux 2.6.38-rc5
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <AANLkTimnLPF0wz+ya-Wj1U1hQjPJpUhmL893OxBWqZYM@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	 <1297854842.3201.197.camel@edumazet-laptop>
	 <AANLkTimnLPF0wz+ya-Wj1U1hQjPJpUhmL893OxBWqZYM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 17:22:39 +0100
Message-ID: <1297873359.30541.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 février 2011 à 07:46 -0800, Linus Torvalds a écrit :
> On Wed, Feb 16, 2011 at 3:14 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > Using this kernel on my dev machine (2x4x2 cpus), I hit BUG_ON() in
> > fs/namei.c:1461 on my kernel build (make -j16)
> 
> Uhhuh. We replaced one BUG_ON() with another.
> 
> And I think it's a really silly problem too: when Al moved the
> 
>         /* We drop rcu-walk here */
>         if (nameidata_dentry_drop_rcu_maybe(nd, path->dentry))
>                 return -ECHILD;
> 
> test into do_follow_link(), he _should_ have moved the BUG_ON() in
> there too, methinks. He didn't, and as a result the BUG_ON() is now
> before the "drop_rcu_maybe".
> 
> This patch should fix it. Al? Comments?
> 

Yes it does, lets see Al patch ;)

> (Of course, we could just remove the BUG_ON() entirely, but
> considering that this is still fragile new code I'd rather leave it
> in)
> 
>                                Linus


