Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1GGNIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:08:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45432 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab1GGNIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:08:24 -0400
MIME-Version: 1.0
In-Reply-To: <1310011371.3309.2.camel@offbook>
References: <1310011371.3309.2.camel@offbook>
Date: Thu, 7 Jul 2011 16:08:22 +0300
Message-ID: <CAGTPOqdm7_PP68mKLQT3gigmUMD6wpoKk3sSWfXk9jeJPX+_6A@mail.gmail.com>
Subject: Re: [PATCH] uml: free resources
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: dave@gnu.org
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        uml <user-mode-linux-devel@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Jim Meyering <meyering@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 7:02 AM, Davidlohr Bueso <dave@gnu.org> wrote:
> From: Davidlohr Bueso <dave@gnu.org>
>
> When creating the temp file there's a memory and file descriptor leak upon error.
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/um/os-Linux/mem.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
> index e696144..62878cf 100644
> --- a/arch/um/os-Linux/mem.c
> +++ b/arch/um/os-Linux/mem.c
> @@ -176,7 +176,7 @@ static int __init make_tempfile(const char *template, char **out_tempname,
>
>        find_tempdir();
>        if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
> -               return -1;
> +               goto out;
>
>        if (template[0] != '/')
>                strcpy(tempname, tempdir);
> @@ -191,13 +191,15 @@ static int __init make_tempfile(const char *template, char **out_tempname,
>        }
>        if (do_unlink && (unlink(tempname) < 0)) {
>                perror("unlink");
> -               goto out;
> +               goto close;
>        }
>        if (out_tempname) {
>                *out_tempname = tempname;
>        } else
>                free(tempname);
>        return fd;
> +close:
> +       close(fd);
>  out:
>        free(tempname);
>        return -1;
> --

Reviewed-by: Vitaliy Ivanov <vitalivanov@gmail.com>
