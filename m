Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2DYOkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:40:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40318 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2DYOke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:40:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120425112629.26927.21609.stgit@zurg>
References: <20120425112623.26927.43229.stgit@zurg>
	<20120425112629.26927.21609.stgit@zurg>
Date: Wed, 25 Apr 2012 16:40:32 +0200
X-Google-Sender-Auth: fWDMXOOdkBuC4i0_6OkeG3CnwE8
Message-ID: <CAMuHMdW7eQh8eaNZrwRHqduPYCjNXv+LriZoH6-ERdkHH2qL8g@mail.gmail.com>
Subject: Re: [PATCH 2/4] bug: completely remove code of disabled VM_BUG_ON()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 13:26, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> Even if CONFIG_DEBUG_VM=n gcc genereates code for some VM_BUG_ON()

That's because of the side effects of the expression

https://lkml.org/lkml/2012/4/25/146

But IRIC, we do want them here?

> bloat-o-meter: add/remove: 0/1 grow/shrink: 10/120 up/down: 185/-1889 (-1704)
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  include/linux/mmdebug.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> index c04ecfe..9c9a2a0 100644
> --- a/include/linux/mmdebug.h
> +++ b/include/linux/mmdebug.h
> @@ -4,7 +4,7 @@
>  #ifdef CONFIG_DEBUG_VM
>  #define VM_BUG_ON(cond) BUG_ON(cond)
>  #else
> -#define VM_BUG_ON(cond) do { (void)(cond); } while (0)
> +#define VM_BUG_ON(cond) unused_expression(cond)
>  #endif
>
>  #ifdef CONFIG_DEBUG_VIRTUAL

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
