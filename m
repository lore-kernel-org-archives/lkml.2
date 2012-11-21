Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2KUQ6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:58:35 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:32899 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2KUQ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:58:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121121072959.GK7615@quad.lixom.net>
References: <1353451739-6317-1-git-send-email-dianders@chromium.org>
	<20121121072959.GK7615@quad.lixom.net>
Date: Wed, 21 Nov 2012 08:58:30 -0800
X-Google-Sender-Auth: oxmj58bVjMi_ccg3NT-pXR1e9YE
Message-ID: <CAD=FV=VtkAtASOBY3sSOyN3oeOZ9=fCJusVz7r+CCqBgX2=nqQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: exynos: add UART3 to DEBUG_LL ports
From: Doug Anderson <dianders@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:29 PM, Olof Johansson <olof@lixom.net> wrote:
>
> On Tue, Nov 20, 2012 at 02:48:58PM -0800, Doug Anderson wrote:
> > From: Olof Johansson <olof@lixom.net>
> >
> > UART3 is used for debugging on exynos5250-snow.
> >
> > [dianders: cleaned commit message.]
> >
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
>
> >
> > ---
> >  arch/arm/Kconfig.debug        |   11 +++++++++++
> >  arch/arm/plat-samsung/Kconfig |    1 +
> >  2 files changed, 12 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> > index 33a8930..35ba7dc 100644
> > --- a/arch/arm/Kconfig.debug
> > +++ b/arch/arm/Kconfig.debug
> > @@ -355,6 +355,17 @@ choice
> >                 The uncompressor code port configuration is now handled
> >                 by CONFIG_S3C_LOWLEVEL_UART_PORT.
> >
> > +     config DEBUG_S3C_UART3
> > +             depends on PLAT_SAMSUNG
>
>
> Sorry, the reason I hadn't re-posted this is that Kukjin had proposed
> to protect users of <= 3 UART platforms to select it. An added "Depends
> on ARCH_EXYNOS4 || ARCH_EXYNOS5" should cover that. Can you add and
> repost, please?

Doh!  I hadn't even noticed that you'd already posted this--I got mine
from the Chrome OS tree directly.  Sorry about that...

I've added an && for ARCH_EXYNOS which seems reasonable.  I left
PLAT_SAMSUNG as a depend though technically ARCH_EXYNOS does select
PLAT_SAMSUNG through a convoluted series of other config options.

-Doug
