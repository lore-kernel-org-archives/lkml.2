Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab1LBRrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:47:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51611 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab1LBRrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:47:20 -0500
Message-ID: <1322848025.3780.8.camel@lappy>
Subject: Re: [PATCH v2] pipe: Fail cleanly when root tries F_SETPIPE_SZ with
 big size
From: Sasha Levin <levinsasha928@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Date: Fri, 02 Dec 2011 19:47:05 +0200
In-Reply-To: <CAOJsxLFvVUbnHrCKGL-kuN_JYQ6qwtU_kzvncrAmWAdjP2RvQw@mail.gmail.com>
References: <1321688059-3844-1-git-send-email-levinsasha928@gmail.com>
	 <CAOJsxLFvVUbnHrCKGL-kuN_JYQ6qwtU_kzvncrAmWAdjP2RvQw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, Ping?

On Sat, 2011-11-19 at 10:06 +0200, Pekka Enberg wrote:
> On Sat, Nov 19, 2011 at 9:34 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> > When a user with the CAP_SYS_RESOURCE cap tries to F_SETPIPE_SZ a pipe with
> > size bigger than what kmalloc() can alloc it spits out an ugly warning:
> 
> [snip]
> 
> > Instead, make kcalloc() handle the overflow case and fail quietly.
> >
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: linux-fsdevel@vger.kernel.org
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> 
> Acked-by: Pekka Enberg <penberg@kernel.org>
> 
> > ---
> >  fs/pipe.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/pipe.c b/fs/pipe.c
> > index 4065f07..3e38dc6 100644
> > --- a/fs/pipe.c
> > +++ b/fs/pipe.c
> > @@ -1137,7 +1137,7 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long nr_pages)
> >        if (nr_pages < pipe->nrbufs)
> >                return -EBUSY;
> >
> > -       bufs = kcalloc(nr_pages, sizeof(struct pipe_buffer), GFP_KERNEL);
> > +       bufs = kcalloc(nr_pages, sizeof(struct pipe_buffer), GFP_KERNEL | __GFP_NOWARN);
> >        if (unlikely(!bufs))
> >                return -ENOMEM;
> >
> > --
> > 1.7.8.rc1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

-- 

Sasha.

