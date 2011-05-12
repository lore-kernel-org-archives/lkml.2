Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab1ELSBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:01:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758405Ab1ELSBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:01:36 -0400
MIME-Version: 1.0
In-Reply-To: <1305222389.21868.10.camel@lade.trondhjem.org>
References: <87fwokarjj.fsf@tucsk.pomaz.szeredi.hu> <BANLkTin6Ujea+qdkvwkH_9o5F8WKPyFdyA@mail.gmail.com>
 <BANLkTi=4rdtB5dQH=tycT1sybe7iJmTVcA@mail.gmail.com> <1305217732.15566.31.camel@lade.trondhjem.org>
 <BANLkTikBVAJSmBZrAvJ6fRQD32TFNeO4zQ@mail.gmail.com> <1305222389.21868.10.camel@lade.trondhjem.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 11:01:12 -0700
Message-ID: <BANLkTinQzWx3f11v+w588z4CFBp8QT7xmA@mail.gmail.com>
Subject: Re: [GIT PULL] fuse fix for 2.6.39
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:46 AM, Trond Myklebust
<Trond.Myklebust@netapp.com> wrote:
>
> I was thinking rather of just returning an EIO if people try. We know
> that there are breakages w.r.t. certain operations as I pointed out in
> my previous email.

Umm. Returning an error is ok, but only if you _need_ to return an error.

Returning an error because you don't like it - that's just wrong.

So I would seriously suggest you return an error only when you really
need something from the nd. So I'd suggest
 - for the automount case, return an error, since you can't change the filp
 - for the LOOKUP_RCU case, just do the "nd && (nd->flags & LOOKUP_RCU)"

The really doesn't seem to be many cases that really need the nd, so
why make it a hard error? *Most* users of nd already check for NULL,
either directly or indirectly (ie "if (!is_atomic_open(nd)) goto
no_open")

                   Linus
