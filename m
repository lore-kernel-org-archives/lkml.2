Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1CTJ4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 05:56:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1CTJ4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 05:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L2g8pqNLQ+LLOTE/Yhj2lP0gxHHT1BfYIUW4azTKac62gI9FmWK858foJtpzu4rXUG
         H6Ct689Mqsu74PX4PeS0aSIybAcj91AVyBga8ESGFgRx7HqvODqsd5rYECvREPWP5kuN
         DkXjDwvyrv1QZKAwRyf/owyrHu4W83fez4i1Q=
MIME-Version: 1.0
In-Reply-To: <201101072259.p07Mx7q6020515@hera.kernel.org>
References: <201101072259.p07Mx7q6020515@hera.kernel.org>
Date: Sun, 20 Mar 2011 10:56:01 +0100
X-Google-Sender-Auth: nf7cn6dcqXqxs9hKhF_bTOI9SLk
Message-ID: <AANLkTikM8DR7RWvFYRX7PcoWOm+UkCJ3SsoQCEhF9pOr@mail.gmail.com>
Subject: Re: n_gsm: clean up printks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@linux.intel.com>, Ken Mills <ken.k.mills@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 23:59, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/5f9a31d63105c3e88bd6d026e7bc53f02a5ac042
> Commit:     5f9a31d63105c3e88bd6d026e7bc53f02a5ac042
> Parent:     c2f2f0000bb69f067fea12624272e6a58a811702
> Author:     Alan Cox <alan@linux.intel.com>
> AuthorDate: Thu Nov 4 15:17:27 2010 +0000
> Committer:  Greg Kroah-Hartman <gregkh@suse.de>
> CommitDate: Thu Nov 11 11:35:58 2010 -0800
>
>    n_gsm: clean up printks
>
>    [Original From Ken Mills but I redid it using pr_ helpers instead]

> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 5256087..11a25fa 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c

> @@ -526,11 +530,13 @@ static void hex_packet(const unsigned char *p, int len)
>  {
>        int i;
>        for (i = 0; i < len; i++) {
> -               if (i && (i % 16) == 0)
> -                       printk("\n");
> -               printk("%02X ", *p++);
> +               if (i && (i % 16) == 0) {
> +                       pr_cont("\n");
> +                       pr_debug("");

drivers/tty/n_gsm.c: In function ‘hex_packet’:
drivers/tty/n_gsm.c:535: warning: zero-length printf format string

Originally reported by Randy
http://linux.derkeiler.com/Mailing-Lists/Kernel/2011-02/msg04880.html

There's no way this is going to be printed nicely. Please use
print_hex_dump() instead.

> +               }
> +               pr_cont("%02X ", *p++);
>        }
> -       printk("\n");
> +       pr_cont("\n");
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
