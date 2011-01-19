Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1ASJcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:32:03 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48279 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1ASJcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lc3WK8GTLX7CwLgLsvhL5jlnz+BY9rPWHeVXYBD8Q7VPvM28Yi9rH4D8hckg+337AV
         r7IW+OlhroF1cUZxW/EXB+nVT5thzaboWNir+Lb+ewWth5ywT5OTjaG2h/vYCmw6CxPu
         bUOJB62fdmJFld2uSNfDaqQ1/Pml/YupFz+EI=
MIME-Version: 1.0
In-Reply-To: <1295426461-12459-1-git-send-email-weber@corscience.de>
References: <1295426461-12459-1-git-send-email-weber@corscience.de>
From: Govindraj <govindraj.ti@gmail.com>
Date: Wed, 19 Jan 2011 15:01:39 +0530
Message-ID: <AANLkTin0-joNuqxqL79j0wqPk_A5mtAgzEY=X=PeH=+C@mail.gmail.com>
Subject: Re: [PATCHv2] OMAP: Enable Magic SysRq on serial console ttyOx
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "Govindraj.R" <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrei Emeltchenko <andrei.emeltchenko@nokia.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 2:11 PM, Thomas Weber <weber@corscience.de> wrote:
> Magic SysRq key is not working for OMAP on new serial
> console ttyOx because SUPPORT_SYSRQ is not defined
> for omap-serial.
>
> This patch defines SUPPORT_SYSRQ in omap-serial and
> enables handling of Magic SysRq character.
>
> Signed-off-by: Thomas Weber <weber@corscience.de>

Looks fine to me.

Acked-by: Govindraj.R <govindraj.raja@ti.com>

> ---
> Changes from v1: Changed comment
>
>  drivers/serial/omap-serial.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
> index 1201eff..907be9b 100644
> --- a/drivers/serial/omap-serial.c
> +++ b/drivers/serial/omap-serial.c
> @@ -20,6 +20,10 @@
>  * this driver as required for the omap-platform.
>  */
>
> +#if defined(CONFIG_SERIAL_OMAP_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> +#define SUPPORT_SYSRQ
> +#endif
> +
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/console.h>
> --
> 1.7.4.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
