Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2IDJKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:10:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48220 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab2IDJKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <50454EDC.7050101@gmail.com>
References: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com>
	<1346681648-21427-4-git-send-email-clouds.yan@gmail.com>
	<50454EDC.7050101@gmail.com>
Date: Tue, 4 Sep 2012 17:10:40 +0800
Message-ID: <CAH+=+MEuVqZhXMELQ=Faewg=4MU2VQr1X1Qq8QCyAu=E-qSeLQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] proc: use kzalloc instead of kmalloc and memset
From: yan yan <clouds.yan@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/4 Ryan Mallon <rmallon@gmail.com>
>
> On 04/09/12 00:14, yan wrote:
> > Signed-off-by: yan <clouds.yan@gmail.com>
> > ---
> >  fs/proc/generic.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> > index 9e8f631..38de015 100644
> > --- a/fs/proc/generic.c
> > +++ b/fs/proc/generic.c
> > @@ -616,10 +616,9 @@ static struct proc_dir_entry *__proc_create(struct
> > proc_dir_entry **parent,
> >
> >       len = strlen(fn);
> >
> > -     ent = kmalloc(sizeof(struct proc_dir_entry) + len + 1,
> > GFP_KERNEL);
> > +     ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1,
> > GFP_KERNEL);
> >       if (!ent) goto out;
> >
> > -     memset(ent, 0, sizeof(struct proc_dir_entry));
> >       memcpy(ent->name, fn, len + 1);
> >       ent->namelen = len;
> >       ent->mode = mode;
>
> Note that this change results in slightly different behaviour. Before
> your change only sizeof(struct proc_dir_entry) is zero'ed by memset, and
> then the name is filled in (the len + 1 part). After your change the
> structure and the name field are both zeroed, so the name field is being
> written to twice. The cost is probably negligible though.

Oh, I didn't notice that actually. Thank you.
