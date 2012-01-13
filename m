Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2AMOGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:06:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63658 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2AMOGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:06:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120113130218.GJ23916@ZenIV.linux.org.uk>
References: <CAPM=9tzbgk=O6iTAM1Vp3SuZLkt7NnaMx0=+wbpW1x+sXk-3zA@mail.gmail.com>
	<1326458657.2219.24.camel@perseus.themaw.net>
	<20120113130218.GJ23916@ZenIV.linux.org.uk>
Date: Fri, 13 Jan 2012 14:06:15 +0000
Message-ID: <CAPM=9txLPv2q+T_KioLYuQv21RAeaphEGm-W+LYtXHYoubbwww@mail.gmail.com>
Subject: Re: autofs4 hung task
From: Dave Airlie <airlied@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ian Kent <raven@themaw.net>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ftp.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Thanks Dave, an obvious mistake I missed in a recent commit by the look
>> of it.
>>
>> Ian
>
> Grr...  Note to self: do git status *and* git stash show -p before git push.
> Nothing like "WTF?  I'd fixed that braino" feeling ;-/
>
> mutex_lock misspelled as mutex_unlock
>
> Buggered-in: commit d668dc56631da067540b2494d2a1f29ff7b5f15a
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks guys, up and running with Linus master with this patch.

Tested-by: Dave Airlie <airlied@redhat.com>

> ---
> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> index 9ef5b29..da8876d 100644
> --- a/fs/autofs4/waitq.c
> +++ b/fs/autofs4/waitq.c
> @@ -76,7 +76,7 @@ static int autofs4_write(struct autofs_sb_info *sbi,
>                data += wr;
>                bytes -= wr;
>        }
> -       mutex_lock(&sbi->pipe_mutex);
> +       mutex_unlock(&sbi->pipe_mutex);
>
>        set_fs(fs);
>
