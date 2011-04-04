Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1DDSDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:03:16 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39609 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab1DDSDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Sg6JTs4M2upQdK3x2d+PvVIR6GilHjVvF2k17v4u+RaBEN8VUgK6ihmdYWlSev/MUY
         EHiV9RpydUXjIQuha5YTZPXGGRMbdTQmTvCeqP3NWIbKBU35md7vxGlzggf/R4YAlVjk
         w+aeHbMxm7gNBycokStI9ulzCrmANhzBOX8O4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <c428cc13a1a5953be3310237e4f404ec65968d5a.1301936559.git.joe@perches.com>
References: <664bf5e5585f3d959d6c57524d09353dd8d49f3f.1301936559.git.joe@perches.com>
	<20110404130036.GB16669@srcf.ucam.org>
	<c428cc13a1a5953be3310237e4f404ec65968d5a.1301936559.git.joe@perches.com>
Date: Mon, 4 Apr 2011 20:03:13 +0200
Message-ID: <BANLkTinKXtiNE=4xfNMh+nJBpiYUYFNRZQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] thinkpad_acpi: Convert printks to pr_<level>
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 7:06 PM, Joe Perches <joe@perches.com> wrote:
> Add pr_fmt.
> Removed local TPACPI_<level> #defines, convert to pr_<level>.
> Neaten dbg_<foo> macros.
> Added a few missing newlines to logging messages.
> Added static inline str_supported for !CONFIG_THINKPAD_ACPI_DEBUG vdbg_printk
> defect reported by Sedat Dilek <sedat.dilek@googlemail.com>.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/platform/x86/thinkpad_acpi.c |  472 ++++++++++++++--------------------
>  1 files changed, 188 insertions(+), 284 deletions(-)
>
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
[...]
>  #ifdef CONFIG_THINKPAD_ACPI_DEBUG
>  #define vdbg_printk dbg_printk
>  static const char *str_supported(int is_supported);
>  #else
> -#define vdbg_printk(a_dbg_level, format, arg...) \
> -       do { } while (0)
> +static inline const char *str_supported(int is_supported) { return ""; }
> +#define vdbg_printk(a_dbg_level, format, arg...)       \
> +       no_printk(format, ##arg)
>  #endif

Should be...
+       do { } while (0)
...not...
+       no_printk(format, ##arg)

- Sedat -
