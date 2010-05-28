Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab0E1KNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:13:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37842 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0E1KNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:13:50 -0400
To: Changli Gao <xiaosuo@gmail.com>
CC: miklos@szeredi.hu, axboe@kernel.dk, viro@zeniv.linux.org.uk,
       mszeredi@suse.cz, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <AANLkTill8Y1RNTzZ9BFmVHPxLyx7CZIL5okqUCRVrrmH@mail.gmail.com>
	(message from Changli Gao on Fri, 28 May 2010 18:00:32 +0800)
Subject: Re: [PATCH v2 4/4] splice: fix updating sd->pos wrongly
References: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHw5Q-00020q-Dk@pomaz-ex.szeredi.hu> <AANLkTill8Y1RNTzZ9BFmVHPxLyx7CZIL5okqUCRVrrmH@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1OHwZC-0002KS-EJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 May 2010 12:13:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Changli Gao wrote:
> On Fri, May 28, 2010 at 5:42 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Wed, 26 May 2010, Changli Gao wrote:
> >> fix updating sd->pos wrongly.
> >>
> >> In error path, we don't need to updating sd->pos, if the file isn't seekable.
> >
> > This patch is nonsense.  Why should we handle sd->pos != 0 case
> > differently?
> >
> 
> If the in file isn't seekable, its splice_read won't update *ppos, so
> in the error path, we'd better not change it too. Otherwise, some
> assumption will go wrong.

That may be true, but the patch is still nonsense.

Look, your patch is updating/not updating sd->pos based on whether it
is zero or not.  It will prevent updating the position for sockets,
but it will also prevent updating the position for regular files if
the position is zero, which is really not what we want.

Since these patches modify the behavior of splice in subtle ways, it
would be good if you had some test program to verify that you aren't
breaking something.

Thanks,
Miklos
