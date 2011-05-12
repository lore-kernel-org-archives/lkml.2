Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1ELPNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:13:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581Ab1ELPNP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <87fwokarjj.fsf@tucsk.pomaz.szeredi.hu>
References: <87fwokarjj.fsf@tucsk.pomaz.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 08:12:24 -0700
Message-ID: <BANLkTin6Ujea+qdkvwkH_9o5F8WKPyFdyA@mail.gmail.com>
Subject: Re: [GIT PULL] fuse fix for 2.6.39
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm.

Do we really ever have a NULL 'nd' these days? Can you send me the
backtrace for whatever oops that was reported?

The reason I ask is because at least NFS also does just

        if (nd->flags & LOOKUP_RCU)
                return -ECHILD;

in its nfs_lookup/open_revalidate() functions. As does cifs, ncpfs, p9
and coda from a quick grep.

                        Linus

On Thu, May 12, 2011 at 8:04 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Please pull from
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus
>
> Miklos Szeredi (1):
>      fuse: fix oops in revalidate when called with NULL nameidata
>
> ---
>  fs/fuse/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
