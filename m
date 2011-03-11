Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1CKRaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:30:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52708 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1CKRaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:30:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=elK3XPox4kkSaXklR8700LC3Qrnyu15u4SyVDvesP2v22pRoPdByy2WF/Rkd4NVnH2
         4GvS/hz4TgCOFA7+3t6Gbb1i73ZLWclFtmLRpjvTesCPGwQoPLtrLFIRBGG0kNut6z/j
         OXlqACNkfLMgvQKUsp/zUYvakrKmKq+BzUauU=
MIME-Version: 1.0
In-Reply-To: <1299107978-3248-1-git-send-email-bookjovi@gmail.com>
References: <1299107978-3248-1-git-send-email-bookjovi@gmail.com>
Date: Fri, 11 Mar 2011 18:22:38 +0100
X-Google-Sender-Auth: PXM1R7rEp4VZybaabUDmBPmL8mY
Message-ID: <AANLkTinXc7uwCdZAFGqg=9ZsWGzos14F8d9YxhCA0q43@mail.gmail.com>
Subject: Re: [PATCH] nfs: fix compilation warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: bookjovi@gmail.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, stable <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 00:19,  <bookjovi@gmail.com> wrote:
> From: Jovi Zhang <bookjovi@gmail.com>
>
> this commit fix compilation warning as following:
> linux-2.6/fs/nfs/nfs4proc.c:3265: warning: comparison of distinct pointer types lacks a cast

And as the offender is on track for 2.6.37.4-stable, it needs to be
applied there, too.

> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> ---
>  fs/nfs/nfs4proc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> index 1ff76ac..c7eb4ee 100644
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -3262,7 +3262,7 @@ static int buf_to_pages_noslab(const void *buf, size_t buflen,
>        spages = pages;
>
>        do {
> -               len = min(PAGE_CACHE_SIZE, buflen);
> +               len = min((size_t)PAGE_CACHE_SIZE, buflen);

Alternatively, we could use

len = min_t(size_t, PAGE_CACHE_SIZE, buflen);

which may be somewhat cleaner, as it doesn't add an explicit cast.

>                newpage = alloc_page(GFP_KERNEL);
>
>                if (newpage == NULL)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
