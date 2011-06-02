Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1FBABG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 20:01:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65492 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203Ab1FBABF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 20:01:05 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=xdMmZEh6R7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=MEF8tz2C7hFxq5HU2Z0A:9 a=oYrivcGFLWGc6gK_5jgA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ide: Fix bug caused by git merge
From: Steven Rostedt <rostedt@goodmis.org>
To: Junio C Hamano <gitster@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>, LKML <linux-kernel@vger.kernel.org>,
        axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <7vmxi1fbxs.fsf@alter.siamese.dyndns.org>
References: <1306956328.10135.36.camel@gandalf.stny.rr.com>
	 <BANLkTimgjdFQcSfOOFFjmSC+Wt_xPXr4Xg@mail.gmail.com>
	 <7vr57dfc8x.fsf@alter.siamese.dyndns.org>
	 <7vmxi1fbxs.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 01 Jun 2011 20:01:02 -0400
Message-ID: <1306972862.3667.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 15:01 -0700, Junio C Hamano wrote:

> With --conflict=diff3, it becomes crystal clear that g->events assignment
> needs to be removed for even somebody who does not know the history of
> this part of the kernel at all (like me).

OK, I like this. This has been one of my biggest complaints about
conflicts in git over the old .rej files that patch produced. In fact, I
find myself using a script from Peter Zijlstra that creates .rej files
from git conflicts, and puts back the old file before the commit was
done.

The default git commit shows you change1 and change2. It does not show
you what it was before either change. With a conflict giving a .rej
file, you see what is there now, what it was that you were trying to
commit, as well as what that commit expected to be there but wasn't. The
default git conflict lacks that last part. I have to remember this
option as it shows what I was missing from patch.

Thanks!

-- Steve

> 
> diff --cc drivers/ide/ide-cd.c
> index 6e5123b,a5ec5a7..0000000
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@@ -1781,8 -1781,7 +1781,15 @@@ static int ide_cd_probe(ide_drive_t *dr
>   
>         ide_cd_read_toc(drive, &sense);
>         g->fops = &idecd_ops;
> ++<<<<<<< ours
>  +      g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
>  +      g->events = DISK_EVENT_MEDIA_CHANGE;
> ++||||||| base
> +       g->flags |= GENHD_FL_REMOVABLE;
> ++      g->events = DISK_EVENT_MEDIA_CHANGE;
> ++=======
> ++      g->flags |= GENHD_FL_REMOVABLE;
> ++>>>>>>> theirs
>         add_disk(g);
>         return 0;


