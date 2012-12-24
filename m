Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2LXO00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 09:26:26 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36475 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2LXO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 09:26:24 -0500
MIME-Version: 1.0
In-Reply-To: <50CA8129.2020206@asianux.com>
References: <50C85644.7020203@asianux.com>
	<50C858AA.8080305@asianux.com>
	<CAJ6Av5OC+2wdfhb2FExv8NM7Hsyu4_1qnCWV22di8_psw4gF4Q@mail.gmail.com>
	<50CA8129.2020206@asianux.com>
Date: Mon, 24 Dec 2012 08:26:22 -0600
Message-ID: <CAJ6Av5PqZoW7s94J6MfmiN6kLzYZHH5Cv6qBA+xq65aPO0KA7g@mail.gmail.com>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: pr_err and pr_debug for
 uninitialized buffer (name buf not initialized).
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 13, 2012 at 7:30 PM, Chen Gang <gang.chen@asianux.com> wrote:
>   also another suggestions:
>     I built ti otmap with ti dsp bridge by arm cross-compiler under i386 platform.
>     the version tag is next-20121213
>     I met 2 compiling issues.
>
>       a: module dependency:
>         Multifunction device drivers --> Texas Instruments TWL/4030/TWL5030.... is required for TI OTMAP.
>         it need depend on CONFIG_REGMAP (maybe also inculde CONFIG_REGMAP*)
>         if CONFIG_REGMAP* not defined, building will be failed.

This is not related to tidspbridge, I sent a patch anyway as it looks
to be a valid build dependency bug.

>       b: version merging issue:
>         in drivers/staging/tidspbridge/core/_tiomap.h
>         need use "#include <mach-omap2/cm3xxx.h>" instead of "#include <mach-omap2/cm2xxx_3xxx.h>"
>         the macro OMAP3430_CM_AUTOIDLE_PLL has already move from cm2xxx_3xxx.h to cm3xxx.h.
>           (it seems arch/arm/mach-omap2/ is not a suitable place for including, but we have to)
>         if not change, compiling will be failed.

Done.

Cheers,

Omar
