Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab2AMONM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:13:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51053 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2AMONI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:13:08 -0500
MIME-Version: 1.0
In-Reply-To: <20120113124145.31045.22056.stgit@web.messagingengine.com>
References: <20120113124145.31045.22056.stgit@web.messagingengine.com>
Date: Fri, 13 Jan 2012 14:13:08 +0000
Message-ID: <CAPM=9tzDWBK2iqCONJm4WAJTvyHK5sQD6aAEpJP=aMebogN3qw@mail.gmail.com>
Subject: Re: [PATCH] autofs4 - fix deal with autofs4_write races
From: Dave Airlie <airlied@gmail.com>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ftp.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:41 PM, Ian Kent <raven@themaw.net> wrote:
> I don't know how I missed this obvious mistake when I
> reviewed Als' patches, sorry.
>
> Signed-off-by: Ian Kent <raven@themaw.net>

Tested-by: Dave Airlie <airlied@redhat.com>

Same as Al's one I acked earlier.

Dave.
> ---
>
>  fs/autofs4/waitq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
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
>
