Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2JCAn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:43:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53435 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2JCAnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121002234934.GA9194@www.outflux.net>
References: <20121002234934.GA9194@www.outflux.net>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 2 Oct 2012 20:43:04 -0400
Message-ID: <CAHGf_=q3_EBCx+=ZL1cY7Q3=rQOiEhK3F7X-0fHd3A5_S+GUSg@mail.gmail.com>
Subject: Re: [PATCH] mm: use %pK for /proc/vmallocinfo
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Joe Perches <joe@perches.com>, Kautuk Consul <consul.kautuk@gmail.com>,
        linux-mm@kvack.org, Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 7:49 PM, Kees Cook <keescook@chromium.org> wrote:
> In the paranoid case of sysctl kernel.kptr_restrict=2, mask the kernel
> virtual addresses in /proc/vmallocinfo too.
>
> Reported-by: Brad Spengler <spender@grsecurity.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  mm/vmalloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 2bb90b1..9c871db 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2572,7 +2572,7 @@ static int s_show(struct seq_file *m, void *p)
>  {
>         struct vm_struct *v = p;
>
> -       seq_printf(m, "0x%p-0x%p %7ld",
> +       seq_printf(m, "0x%pK-0x%pK %7ld",
>                 v->addr, v->addr + v->size, v->size);

Looks good.
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
