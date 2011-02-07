Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1BGMkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:40:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45173 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1BGMkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:40:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ukOfqZNzMFwV77Q5Ap8cx53mzADpuX+U/hiuuY/o/G+j/wXPNiFhTfISMdcp9PGn4Y
         HsYyDl4DYA/ABFnuwOXRCuw0L/ym83LbgB01lQe8qvMYtsLxhZZ/58mUoq/g1VPhK7pU
         cokUhFsPq1ms4h0o/0+9sCHEXSzDILi79XJLs=
MIME-Version: 1.0
In-Reply-To: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Mon, 7 Feb 2011 13:40:28 +0100
X-Google-Sender-Auth: pT22dtj-fF19iwy3pPwedv6DNdM
Message-ID: <AANLkTimxpRHW2TPwSnufpoeOHoEtkz1iaR3-VsC1qM4j@mail.gmail.com>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 13:22, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> It is very rare to find a current system which is both sufficiently
> resource constrained to want to compile out power management support
> and sufficiently power insensitive to be able to tolerate doing so.

Hmmm...

> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -1,23 +1,6 @@
>  config PM
> -       bool "Power Management support"
> -       depends on !IA64_HP_SIM
> -       ---help---
> -         "Power Management" means that parts of your computer are shut
> -         off or put into a power conserving "sleep" mode if they are not
> -         being used.  There are two competing standards for doing this: APM
> -         and ACPI.  If you want to use either one, say Y here and then also
> -         to the requisite support below.

Good to see the PC-centric comments are going away :-)

> -
> -         Power Management is most important for battery powered laptop
> -         computers; if you have a laptop, check out the Linux Laptop home
> -         page on the WWW at <http://www.linux-on-laptops.com/> or
> -         Tuxmobil - Linux on Mobile Computers at <http://www.tuxmobil.org/>
> -         and the Battery Powered Linux mini-HOWTO, available from
> -         <http://www.tldp.org/docs.html#howto>.
> -
> -         Note that, even if you say N here, Linux on the x86 architecture
> -         will issue the hlt instruction if nothing is to be done, thereby
> -         sending the processor to sleep and saving power.
> +       bool
> +       default y if !IA64_HP_SIM

The following architectures do not source "kernel/power/Kconfig":

alpha
cris
h8300
Kconfig
m32r
m68k
m68knommu
microblaze
parisc
score
sparc
tile
um
xtensa

Which means that (for now) I don't have to care that CONFIG_PM becomes
unclearable. Other people may care, though...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
