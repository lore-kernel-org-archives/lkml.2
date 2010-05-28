Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0E1Lk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:40:59 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36458 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab0E1Lk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:40:58 -0400
To: Changli Gao <xiaosuo@gmail.com>
CC: miklos@szeredi.hu, axboe@kernel.dk, viro@zeniv.linux.org.uk,
       mszeredi@suse.cz, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <AANLkTinBmZej_rQFQ_bMPJf9GGJFFW3zdnpqZTXZCIfc@mail.gmail.com>
	(message from Changli Gao on Fri, 28 May 2010 19:36:36 +0800)
Subject: Re: [PATCH v2 4/4] splice: fix updating sd->pos wrongly
References: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHw5Q-00020q-Dk@pomaz-ex.szeredi.hu> <AANLkTill8Y1RNTzZ9BFmVHPxLyx7CZIL5okqUCRVrrmH@mail.gmail.com> 
	<E1OHwZC-0002KS-EJ@pomaz-ex.szeredi.hu> <AANLkTikJMLiaUIVohTPy4DLF4XmWsy7LCx0bDheq2aHM@mail.gmail.com> 
	<E1OHxTV-0002u1-Vo@pomaz-ex.szeredi.hu> <AANLkTinBmZej_rQFQ_bMPJf9GGJFFW3zdnpqZTXZCIfc@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1OHxvZ-00030j-7t@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 May 2010 13:40:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Changli Gao wrote:
> On Fri, May 28, 2010 at 7:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Fri, 28 May 2010, Changli Gao wrote:
> >>  Before checking the sd->pos, sd->pos
> >> already is updated with the value returned by splice_read(), so if in
> >> file is seekabble, sd->pos is non-zero when I checking it.
> >
> > I see the logic now.  But it's really confusing, at least some
> > comments would be needed.
> >
> > But I think it would be better not to try reusing sd->pos for reading,
> > but supplying an "loff_t *read_ppos" to splice_direct_to_actor and
> > leaving sd->pos alone (for the write side to use and update as
> > necessary).
> >
> 
>                if (ret < read_len) {
> 
> I think is much like a hack too. :)
> 
> -                       sd->pos = prev_pos + ret;
> +                       if (sd->pos)
> +                               sd->pos = prev_pos + ret;
>                        goto out_release;
>                }
> 
> Anyway, it can fix the issue I mentioned above. Any future cleanup
> should not be mixed in, IMO.

Okay, but please add a comment and explaing in the patch header,
because others are going to look a that code and go "WTF???"

Thanks,
Miklos
