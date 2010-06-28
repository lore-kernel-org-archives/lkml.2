Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0F1CWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 22:22:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33151 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0F1CWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 22:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h1WVE7OIQbMJddyAHNkZ/f/IcgwBrPkvy+KmZKHAxvHqrivqV+8g8l0XeAcDv4B0Dz
         llMAguZvp04u9lPTcIou/54ccUIFuJ4vDznT0DX6a3f9NRRD4TAglw8rH9P7ifxo89I3
         sy3JdnMkjmapZvH9+cjT2Cjx9wbeXzTIK+y0s=
MIME-Version: 1.0
In-Reply-To: <1276767215-4217-1-git-send-email-andy.shevchenko@gmail.com>
References: <1276767215-4217-1-git-send-email-andy.shevchenko@gmail.com>
Date: Mon, 28 Jun 2010 10:22:42 +0800
Message-ID: <AANLkTim7CGIWmw1W2_XI-ApaVP6dg5ApVEq3bzFVKHnG@mail.gmail.com>
Subject: Re: [PATCH] kgdb: remove custom hex_to_bin() implementation
From: Dongdong Deng <libfetion@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Jason Wessel <jason.wessel@windriver.com>, Martin Hicks <mort@sgi.com>,
       kgdb-bugreport@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is ok to me. :-)

Best Regards,
Dongdong

On Thu, Jun 17, 2010 at 5:33 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
>
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: Martin Hicks <mort@sgi.com>
> Cc: kgdb-bugreport@lists.sourceforge.net
> ---
>  kernel/debug/gdbstub.c |   21 +++++----------------
>  1 files changed, 5 insertions(+), 16 deletions(-)
>
> diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
> index 4b17b32..d721b1b 100644
> --- a/kernel/debug/gdbstub.c
> +++ b/kernel/debug/gdbstub.c
> @@ -52,17 +52,6 @@ static unsigned long         gdb_regs[(NUMREGBYTES +
>  * GDB remote protocol parser:
>  */
>
> -static int hex(char ch)
> -{
> -       if ((ch >= 'a') && (ch <= 'f'))
> -               return ch - 'a' + 10;
> -       if ((ch >= '0') && (ch <= '9'))
> -               return ch - '0';
> -       if ((ch >= 'A') && (ch <= 'F'))
> -               return ch - 'A' + 10;
> -       return -1;
> -}
> -
>  #ifdef CONFIG_KGDB_KDB
>  static int gdbstub_read_wait(void)
>  {
> @@ -123,8 +112,8 @@ static void get_packet(char *buffer)
>                buffer[count] = 0;
>
>                if (ch == '#') {
> -                       xmitcsum = hex(gdbstub_read_wait()) << 4;
> -                       xmitcsum += hex(gdbstub_read_wait());
> +                       xmitcsum = hex_to_bin(gdbstub_read_wait()) << 4;
> +                       xmitcsum += hex_to_bin(gdbstub_read_wait());
>
>                        if (checksum != xmitcsum)
>                                /* failed checksum */
> @@ -280,8 +269,8 @@ int kgdb_hex2mem(char *buf, char *mem, int count)
>        tmp_hex = tmp_raw - 1;
>        while (tmp_hex >= buf) {
>                tmp_raw--;
> -               *tmp_raw = hex(*tmp_hex--);
> -               *tmp_raw |= hex(*tmp_hex--) << 4;
> +               *tmp_raw = hex_to_bin(*tmp_hex--);
> +               *tmp_raw |= hex_to_bin(*tmp_hex--) << 4;
>        }
>
>        return probe_kernel_write(mem, tmp_raw, count);
> @@ -304,7 +293,7 @@ int kgdb_hex2long(char **ptr, unsigned long *long_val)
>                (*ptr)++;
>        }
>        while (**ptr) {
> -               hex_val = hex(**ptr);
> +               hex_val = hex_to_bin(**ptr);
>                if (hex_val < 0)
>                        break;
>
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
