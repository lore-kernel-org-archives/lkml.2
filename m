Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2GYNYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:24:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47071 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2GYNYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:24:02 -0400
MIME-Version: 1.0
In-Reply-To: <1343222119-82246-1-git-send-email-tim.gardner@canonical.com>
References: <1343222119-82246-1-git-send-email-tim.gardner@canonical.com>
Date: Wed, 25 Jul 2012 09:24:01 -0400
Message-ID: <CAGoCfiziwAz0q2D_qKX=1nrAKQybeX+Ho5eu_gsERhd7QtsaDQ@mail.gmail.com>
Subject: Re: [PATCH] xc5000: Add MODULE_FIRMWARE statements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@kernellabs.com>,
        Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 9:15 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
> This will make modinfo more useful with regard
> to discovering necessary firmware files.
>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Michael Krufky <mkrufky@kernellabs.com>
> Cc: Eddi De Pieri <eddi@depieri.net>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/media/common/tuners/xc5000.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
> index dcca42c..4d33f86 100644
> --- a/drivers/media/common/tuners/xc5000.c
> +++ b/drivers/media/common/tuners/xc5000.c
> @@ -210,13 +210,15 @@ struct xc5000_fw_cfg {
>         u16 size;
>  };
>
> +#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.114.fw"
>  static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
> -       .name = "dvb-fe-xc5000-1.6.114.fw",
> +       .name = XC5000A_FIRMWARE,
>         .size = 12401,
>  };
>
> +#define XC5000C_FIRMWARE "dvb-fe-xc5000c-41.024.5.fw"
>  static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
> -       .name = "dvb-fe-xc5000c-41.024.5.fw",
> +       .name = XC5000C_FIRMWARE,
>         .size = 16497,
>  };
>
> @@ -1253,3 +1255,5 @@ EXPORT_SYMBOL(xc5000_attach);
>  MODULE_AUTHOR("Steven Toth");
>  MODULE_DESCRIPTION("Xceive xc5000 silicon tuner driver");
>  MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE(XC5000A_FIRMWARE);
> +MODULE_FIRMWARE(XC5000C_FIRMWARE);
> --

Hi Tim,

I'm just eyeballing the patch and I'm not familiar with this new
functionality, but where are the new macros you're specifying actually
defined?  You're swapping out the filename for XC5000A_FIRMWARE, but
where is the actual reference to "dvb-fe-xc5000-1.6.114.fw"?

Also, Mauro, can I merge this into my tree first rather than you
pulling it direct?  I've got a whole patch series for xc5000 that I'm
slated to issue a PULL for this weekend, and I *really* don't want to
rebase the series for a four line change (which will definitely cause
a conflict).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
