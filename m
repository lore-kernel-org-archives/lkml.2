Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab1FIE0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 00:26:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45826 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1FIE0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 00:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=YoicAuMES3mBomVYXuUK6btsao/5Lk/THL6kZJSn9xeZGzIgogQN/2kUeS6E0U/F5G
         EQwIpMXyxRV7O150y5MT35bKVux7X0st9JDsFD62ige3i/30u352Y01pmZgd83v3gWBk
         YCJXcG/FBGeFRSfW9ql7MfIgnGO75e//ITs7U=
MIME-Version: 1.0
In-Reply-To: <20110609030401.GA2615@gmail.com>
References: <20110609030401.GA2615@gmail.com>
Date: Wed, 8 Jun 2011 21:26:46 -0700
Message-ID: <BANLkTim_=2kWXAzkECC4A3t9uxGERwBU7g@mail.gmail.com>
Subject: Re: [PATCH RESEND]Remove a warning for drivers/edac/i82975x_edac.c
From: Connor Hansen <cmdkhh@gmail.com>
To: linux-kernel@vger.kernel.org, ravi@jetztechnologies.com,
        arvino55@gmail.com, greg@kroah.com, akpm@linux-foundation.org,
        randy.dunlap@oracle.com, joe@perches.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I compile 3.0.0-rc2+ I don't get this warning.
please make sure this issue still exists.

Connor

On Wed, Jun 8, 2011 at 8:04 PM, Harry Wei <jiaweiwei.xiyou@gmail.com> wrote:
> From: Harry Wei <harryxiyou@gmail.com>
>
> When i compile 2.6.39.1, a warning shows like below.
> This patch can fix the warning. And i works well with
> my PC.
>
> [...]
> CC [M]  drivers/edac/e752x_edac.o
> CC [M]  drivers/edac/i82875p_edac.o
> CC [M]  drivers/edac/i82975x_edac.o
> drivers/edac/i82975x_edac.c: In function ���i82975x_process_error_info���:
> drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for ���unsigned long��� type
> CC [M]  drivers/edac/i3000_edac.o
> CC [M]  drivers/edac/i3200_edac.o
> CC [M]  drivers/edac/x38_edac.o
> CC [M]  drivers/edac/i82860_edac.o
> [...]
>
>
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> Index: prj/drivers/edac/i82975x_edac.c
> ===================================================================
> --- prj.orig/drivers/edac/i82975x_edac.c        2011-06-04 10:09:55.351174516 +0800
> +++ prj/drivers/edac/i82975x_edac.c     2011-06-04 10:10:30.875168437 +0800
> @@ -293,9 +293,9 @@
>                info->errsts = info->errsts2;
>        }
>
> -       page = (unsigned long) info->eap;
> +       page = (unsigned long long) info->eap;
>        if (info->xeap & 1)
> -               page |= 0x100000000ul;
> +               page |= 0x100000000ull;
>        chan = page & 1;
>        page >>= 1;
>        offst = page & ((1 << PAGE_SHIFT) - 1);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
