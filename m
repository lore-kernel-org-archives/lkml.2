Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0KBNQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:16:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41881 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0KBNQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uico/o+Ih3oygb0EXIxkAzY88eSYsgQWgaQIJ7L/YmoDfyshYE9mi17bi5czA7gCVO
         LB9xIGCoTKg1MZUaPUQm6ODYpKGl8S2twvJkeUnjXilkjyy9b3tlFrthrvRj8sVcxrO3
         PKV1dR7QS6dct3KtfFkkzglGF3MJk66P3qaHQ=
MIME-Version: 1.0
In-Reply-To: <20101029233109.28692cbf@absol.kitzblitz>
References: <20101029233109.28692cbf@absol.kitzblitz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 2 Nov 2010 21:15:42 +0800
Message-ID: <AANLkTimaHGczcj=Ot=KkBvbA=VcRFztE8jMv3REOex8K@mail.gmail.com>
Subject: Re: [PATCH] mach-pxa: sharpsl_pm: simplify conditional
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 5:31 AM, Nicolas Kaiser <nikai@nikai.net> wrote:
> Simplify: ((a && b) || !a) => (b || !a)
>

This is a good catch, I believe this could be generally applied elsewhere
in the kernel. The problem with sharpsl_pm is that it's currently a mess
and needs a fully rewrite, I'd really like this issue being addressed in that
rewritten version.

> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  arch/arm/mach-pxa/sharpsl_pm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
> index 8fed027..d08763c 100644
> --- a/arch/arm/mach-pxa/sharpsl_pm.c
> +++ b/arch/arm/mach-pxa/sharpsl_pm.c
> @@ -619,7 +619,7 @@ static void corgi_goto_sleep(unsigned long alarm_time, unsigned int alarm_enable
>        PEDR = 0xffffffff; /* clear it */
>
>        sharpsl_pm.flags &= ~SHARPSL_ALARM_ACTIVE;
> -       if ((sharpsl_pm.charge_mode == CHRG_ON) && ((alarm_enable && ((alarm_time - RCNR) > (SHARPSL_BATCHK_TIME_SUSPEND + 30))) || !alarm_enable)) {
> +       if ((sharpsl_pm.charge_mode == CHRG_ON) && (((alarm_time - RCNR) > (SHARPSL_BATCHK_TIME_SUSPEND + 30)) || !alarm_enable)) {
>                RTSR &= RTSR_ALE;
>                RTAR = RCNR + SHARPSL_BATCHK_TIME_SUSPEND;
>                dev_dbg(sharpsl_pm.dev, "Charging alarm at: %08x\n", RTAR);
> --
> 1.7.2.2
>
