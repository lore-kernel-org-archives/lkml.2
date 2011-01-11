Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1AKQIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:08:51 -0500
Received: from mail-ey0-f194.google.com ([209.85.215.194]:49626 "EHLO
	mail-ey0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab1AKQIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:08:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=qcWFynl5in+A+xgoZbwN2Pgw1T5w7h29VPVMSRg0ytpivop+gNcbaCTSj5m1ql10wE
         nmkrnJEWnz5ihfgSec1VXu86owwHSlyyrqI7upjR6JaVTBXkmJ5gWc3tFIRn4/hvIEfQ
         bPGfUnkcZYJ+A2+TqcFO2DfZlj+6S/3QfzEXc=
MIME-Version: 1.0
In-Reply-To: <1294751426-3472-1-git-send-email-lee.jones@linaro.org>
References: <1294751426-3472-1-git-send-email-lee.jones@linaro.org>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 11 Jan 2011 21:38:07 +0530
X-Google-Sender-Auth: 74Fp-Kyo_BXmBTaXlAIvK_2xd3k
Message-ID: <AANLkTimvS9rmrn86-veK3KwP31bqN7mzp2bEiwPEt_RR@mail.gmail.com>
Subject: Re: [PATCH] ux500: Add Rohm BH1780GLI Light Sensor to i2c_board_info
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 18:40, Lee Jones <lee.jones@linaro.org> wrote:
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/mach-ux500/board-mop500.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
> index 2635bb7..ff67408 100644
> --- a/arch/arm/mach-ux500/board-mop500.c
> +++ b/arch/arm/mach-ux500/board-mop500.c
> @@ -134,6 +134,15 @@ static struct i2c_board_info mop500_i2c0_devices[] = {
>        },
>  };
>
> +static struct i2c_board_info mop500_i2c2_devices[] = {
> +#if defined(CONFIG_SENSORS_BH1780)
> +       {
> +               /* Light sensor Rohm BH1780GLI */
> +               I2C_BOARD_INFO("bh1780", 0x29),
> +       },
> +#endif
> +};

You need to take care of the case where the driver is built as a module
(by adding a || defined(..._MODULE)).  It would actually be better if
you instead get rid of the ifdef entirely, since they get really ugly if
you add them for every device here.
