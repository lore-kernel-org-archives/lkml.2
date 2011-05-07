Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1EGMcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 08:32:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63506 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab1EGMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 08:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G9OstgzB81nhAXDvhUG8StJiHN/fYSZQ4OBj/XCOBNzGoHr+o6qQPjLzscDwRFkeWA
         t0/zoVWM5Mc2lTTliRWmrM6WNEmYz6R19mRqGWGelzv+UPBqTNiCERYlJQkemJ9qz7F6
         OrzvzYMt/hANl2ohEQ+b6sYo1B3CEfYwKgZTg=
Subject: Re: [PATCH] fs: add FD_CLOFORK and O_CLOFORK
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Changli Gao <xiaosuo@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <BANLkTiktdStx1e5vHk7AqO+pYVXm-PjsQg@mail.gmail.com>
References: <1304743740-3405-1-git-send-email-xiaosuo@gmail.com>
	 <1304748394.2821.654.camel@edumazet-laptop>
	 <BANLkTi=tZf1uQig8A-WiXUpSWcuqaqV=fg@mail.gmail.com>
	 <1304749754.2821.712.camel@edumazet-laptop>
	 <BANLkTiktdStx1e5vHk7AqO+pYVXm-PjsQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 14:32:05 +0200
Message-ID: <1304771525.2821.1173.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 07 mai 2011 à 13:41 +0200, Geert Uytterhoeven a écrit :
> On Sat, May 7, 2011 at 08:29, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > I am sure the following idea already was discussed in the past :
> >
> > Embed the close_on_exec / close_on_close bits in the low order bits of
> > file pointers.
> 
> How many low order bits do you expect to have in file pointers?
> Are files allocated using kmalloc(), or do they just obey the alignment of the
> individual members of a file struct? In the latter case, you'll have onlyv1 low
> order bit to play with on m68k.

We should have two bits at a very minimum.

clone_on_exec & clone_on_fork would fit.

filp are allocated with a kmem_cachep with cache line alignement.

filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
	SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);

So in practice we should have more than two bits ;)



