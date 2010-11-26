Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0KZHBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:01:33 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36057 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0KZHBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:01:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sVcwzWX4cSHzj4rWwMBOjcle+Z2M3v/Z4xziKkvvApIjVuMRUIdlppvbNqbvtmYkC5
         G6ZUA4Rqu7KjgX2wRZNzavQanEYV98mWv12uMRmoWvg9B0I0hnmvrF7Ur46RoWdyaTrv
         /PNTSFO1YZwEIi0myxz8ay4sOAJJev95tRe8o=
MIME-Version: 1.0
In-Reply-To: <20101122003157.13674.42596.stgit@zaytsev.su>
References: <20101122002747.13674.69384.stgit@zaytsev.su>
	<20101122003157.13674.42596.stgit@zaytsev.su>
Date: Fri, 26 Nov 2010 10:01:30 +0300
Message-ID: <AANLkTin_Ta-Fj2sd+jLSYTaOb0KOpaKdDv5B+2-tTEyG@mail.gmail.com>
Subject: Re: [PATCH 1/4] fanotify: Shrink struct fanotify_event_metadata by 32 bits
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Scott Hassan <hassan@dotfunk.com>, Jan Kara <jack@suse.cz>,
        agruen@linbit.com, linux-kernel@vger.kernel.org, stefan@buettcher.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eric. Sorry for the noise, but could you please comment at this
one? Because if it goes, it needs to go soon, before the .37 release,
or we won't be able change the ABI.

The other patches in the series are clearly not .37 material, so no
problem if you can't look at them right now.

On Mon, Nov 22, 2010 at 03:33, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> And this saves additional 32 bits in the future
>
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> ---
>  include/linux/fanotify.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
> index 0f01214..9a7986f 100644
> --- a/include/linux/fanotify.h
> +++ b/include/linux/fanotify.h
> @@ -86,10 +86,11 @@
>  #define FANOTIFY_METADATA_VERSION      2
>
>  struct fanotify_event_metadata {
> -       __u32 event_len;
> -       __u32 vers;
> -       __aligned_u64 mask;
> +       __u16 event_len;
> +       __u8 vers;
> +       __u8 reserved;
>        __s32 fd;
> +       __aligned_u64 mask;
>        __s32 pid;
>  };
>
>
>
