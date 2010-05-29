Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0E2OJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 10:09:13 -0400
Received: from mail2.shareable.org ([80.68.89.115]:39127 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0E2OJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 10:09:08 -0400
Date: Sat, 29 May 2010 15:09:01 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, axboe@kernel.dk,
       viro@zeniv.linux.org.uk, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] splice: fix updating sd->pos wrongly
Message-ID: <20100529140901.GD3106@shareable.org>
References: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com> <E1OHw5Q-00020q-Dk@pomaz-ex.szeredi.hu> <AANLkTill8Y1RNTzZ9BFmVHPxLyx7CZIL5okqUCRVrrmH@mail.gmail.com> <E1OHwZC-0002KS-EJ@pomaz-ex.szeredi.hu> <AANLkTikJMLiaUIVohTPy4DLF4XmWsy7LCx0bDheq2aHM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikJMLiaUIVohTPy4DLF4XmWsy7LCx0bDheq2aHM@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao wrote:
> On Fri, May 28, 2010 at 6:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Fri, 28 May 2010, Changli Gao wrote:
> >> On Fri, May 28, 2010 at 5:42 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> > On Wed, 26 May 2010, Changli Gao wrote:
> >> >> fix updating sd->pos wrongly.
> >> >>
> >> >> In error path, we don't need to updating sd->pos, if the file isn't seekable.
> >> >
> >> > This patch is nonsense.  Why should we handle sd->pos != 0 case
> >> > differently?
> >> >
> >>
> >> If the in file isn't seekable, its splice_read won't update *ppos, so
> >> in the error path, we'd better not change it too. Otherwise, some
> >> assumption will go wrong.
> >
> > That may be true, but the patch is still nonsense.
> >
> > Look, your patch is updating/not updating sd->pos based on whether it
> > is zero or not.  It will prevent updating the position for sockets,
> > but it will also prevent updating the position for regular files if
> > the position is zero, which is really not what we want.
> 
> I think you misread my patch. Before checking the sd->pos, sd->pos
> already is updated with the value returned by splice_read(), so if in
> file is seekabble, sd->pos is non-zero when I checking it.

Not true if the "file" is /dev/mem or /dev/kmem.  The starting offset
can be negative, so can end at zero.

It's an obscure case and I don't know if you can sendfile from
/dev/{,k}mem anyway :-) but illustrates why sd->pos != 0 is dubious.

-- Jamie
