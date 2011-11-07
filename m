Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1KGLrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:47:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44984 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1KGLr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:47:29 -0500
MIME-Version: 1.0
In-Reply-To: <1320586010-21931-4-git-send-email-julia@diku.dk>
References: <1320586010-21931-1-git-send-email-julia@diku.dk>
	<1320586010-21931-4-git-send-email-julia@diku.dk>
Date: Mon, 7 Nov 2011 13:47:27 +0200
X-Google-Sender-Auth: eeY1QYJerhjnOOkVTivSjFKwguM
Message-ID: <CAB3XZEfHV+sO=+vJdZUQVqXFtHvZyhJQ1Cm8LJ8Puyz9eqq9Kg@mail.gmail.com>
Subject: Re: [PATCH 3/5] net/mac80211/debugfs.c: use kstrtoul, etc
From: Eliad Peller <eliad@wizery.com>
To: Julia Lawall <julia@diku.dk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        kernel-janitors@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 3:26 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Use kstrtoul, etc instead of the now deprecated strict_strtoul, etc.
>
> A semantic patch rule for the kstrtoul case is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression a,b;
> {int,long} *c;
> @@
>
> -strict_strtoul
> +kstrtoul
>  (a,b,c)
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  net/mac80211/debugfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -u -p a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -190,7 +190,7 @@ static ssize_t uapsd_max_sp_len_write(st
>                return -EFAULT;
>        buf[len] = '\0';
>
> -       ret = strict_strtoul(buf, 0, &val);
> +       ret = kstrtoul(buf, 0, &val);
>
>        if (ret)
>                return -EINVAL;
>

maybe while cleaning it up change copy_from_user +
strict_stroul/kstroul -> kstroul_from_user?

Eliad.
