Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1IPNLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:11:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42802 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1IPNLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
Date: Fri, 16 Sep 2011 16:11:06 +0300
Message-ID: <CAHp75VewcqSnEOe5pa1NAYXj9RBOW1OVwZzM0CnEYcQwLfbhcw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/5] lib: add unpack_hex_byte()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 3:50 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Since converting 2 ascii hex digits into a byte with error checks
> is commonly used, we can replace multiple hex_to_bin() calls with
> a single call to unpack_hex_byte().
>
> Changelog:
> - Error checking added based on Tetsuo Handa's patch.
> - Moved the hex2bin code here, making it into a static inline function.
>  (Andy Shevchenko's request.)
>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  include/linux/kernel.h |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 46ac9a5..d8ea13b 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -385,6 +385,27 @@ extern int hex_to_bin(char ch);
>  extern void hex2bin(u8 *dst, const char *src, size_t count);
>
>  /*
> + * unpack_hex_byte - convert 2 asii hex digits into a byte
> + * @byte: binary result
> + * @buf: ascii hexadecimal byte string
> + */
> +static inline bool unpack_hex_byte(u8 *byte, const char *buf)
> +{
> +       int hi, lo;
> +
> +       hi = hex_to_bin(buf[0]);
> +       if (hi < 0)
> +               return false;
> +
> +       lo = hex_to_bin(buf[1]);
> +       if (lo < 0)
> +               return false;
> +
> +       *byte = (hi << 4) | lo;
> +       return true;
> +}
> +
> +/*
>  * General tracing related utility functions - trace_printk(),
>  * tracing_on/tracing_off and tracing_start()/tracing_stop
>  *

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko
