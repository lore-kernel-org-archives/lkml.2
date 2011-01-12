Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1ALQzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:55:36 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45077 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1ALQze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:55:34 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 12 Jan 2011 08:54:41 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: Namhyung Kim <namhyung@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] epoll: remove unnecessary bit operation in epoll_create1
 syscall
In-Reply-To: <AANLkTikgBBEznAh1CRwJk5MgorNFpXvRuVLyhYT6sQvw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101120853090.26965@davide-lnx1>
References: <1294829896-3210-1-git-send-email-namhyung@gmail.com> <AANLkTikgBBEznAh1CRwJk5MgorNFpXvRuVLyhYT6sQvw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1770545212-1294851285=:26965"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1770545212-1294851285=:26965
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 12 Jan 2011, richard -rw- weinberger wrote:

> On Wed, Jan 12, 2011 at 11:58 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> > @flags can have O_CLOEXEC only so bitwise AND is not necessary.
> >
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  fs/eventpoll.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> > index 8cf07242067d..2e21fb85b8b6 100644
> > --- a/fs/eventpoll.c
> > +++ b/fs/eventpoll.c
> > @@ -1209,7 +1209,7 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
> >         * a file structure and a free file descriptor.
> >         */
> >        error = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
> > -                                O_RDWR | (flags & O_CLOEXEC));
> > +                                O_RDWR | flags);
> 
> I'm strong against this.
> Whenever a new flag is allowed this will explode...

His point might be that there is a check right ahead, so flags can't be 
enything outside such mask.
But yeah, this is not worth creating another couple of objects in the GIT 
tree IMO.



- Davide


--8323329-1770545212-1294851285=:26965--
