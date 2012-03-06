Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031490Ab2CFXDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:03:06 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52416 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965287Ab2CFXDE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:03:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.182.159.65 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <1331074162-18147-1-git-send-email-mathieu.poirier@linaro.org>
References: <1331074162-18147-1-git-send-email-mathieu.poirier@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 6 Mar 2012 16:02:44 -0700
X-Google-Sender-Auth: QgviSobQBTSBP2QM0x06qvyOMqs
Message-ID: <CACxGe6v5edmAcicNSgDaKr2ics5q7fGkh4E4zjeSCOSePrJX+g@mail.gmail.com>
Subject: Re: [PATCH] ARM: versatile: automatically pick a board in Kconfig
To: mathieu.poirier@linaro.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 3:49 PM,  <mathieu.poirier@linaro.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The versatile platform supports building any combination of the
> three board types (AB, PB, DT), but at least one of them has
> to be enabled. This adds the necessary Kconfig statement to
> enforce that at least one of the three is selected.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  arch/arm/mach-versatile/Kconfig |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-versatile/Kconfig b/arch/arm/mach-versatile/Kconfig
> index c1f38f6..31da352 100644
> --- a/arch/arm/mach-versatile/Kconfig
> +++ b/arch/arm/mach-versatile/Kconfig
> @@ -25,4 +25,10 @@ config MACH_VERSATILE_DT
>          Include support for the ARM(R) Versatile/PB platform,
>          using the device tree for discovery
>
> +config MACH_VERSATILE_AUTO
> +       def_bool y
> +       depends on !ARCH_VERSATILE_PB
> +       depends on !MACH_VERSATILE_AB
> +       select MACH_VERSATILE_DT
> +
>  endmenu
> --
> 1.7.5.4
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
