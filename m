Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0FGCRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 22:17:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45853 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab0FGCRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 22:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JGsJVGV0o9IHhsrqGEXMtzf/zf4974B/xv4mPy8lXGhKSEHcnel3sVwxVds/7LWV5C
         Lm90LRc/zRmsG2R6R9G0CDC4xFBiXv0zKZRBKjsFjtomEPb/dtvoK5pNGjoMYjw9Y7yf
         cwC6lZS/qDMsSuDvmPDzt7DlCjvXsyB1rszT0=
MIME-Version: 1.0
In-Reply-To: <1275860015-6643-1-git-send-email-jslaby@suse.cz>
References: <4C0C0DD8.5030106@gmail.com> <1275860015-6643-1-git-send-email-jslaby@suse.cz>
From: Frank Pan <frankpzh@gmail.com>
Date: Mon, 7 Jun 2010 10:16:44 +0800
Message-ID: <AANLkTim2CS71Kaoviwv5TFS_lLws__fYaK-HzNOytlML@mail.gmail.com>
Subject: Re: BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, Greg KH <gregkh@suse.de>,
       =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Does the patch below help?
>
> ---
>  drivers/char/vt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index 1296c42..e123958 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -304,8 +304,8 @@ static void scrup(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
>        d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
>        s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
>        scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
> -       scr_memsetw(d + (b - t - nr) * vc->vc_size_row, vc->vc_video_erase_char,
> -                   vc->vc_size_row * nr);
> +       scr_memsetw((void *)d + (b - t - nr) * vc->vc_size_row,
> +                       vc->vc_video_erase_char, vc->vc_size_row * nr);
>  }
>
>  static void scrdown(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
> --
> 1.7.1
>
>
>

This patch fixed the issue. That's my mistake, forgot d's type. Sorry for that.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
