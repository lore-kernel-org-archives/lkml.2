Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1AQMcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 07:32:10 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50957 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1AQMcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 07:32:07 -0500
Message-ID: <4D343680.1030701@ru.mvista.com>
Date: Mon, 17 Jan 2011 15:30:56 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: kernel-janitors@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: mach-omap2: potential NULL dereference
References: <1295258922-31242-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1295258922-31242-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-01-2011 13:08, Vasiliy Kulikov wrote:

> kzalloc() may fail, if so return -ENOMEM.

> Signed-off-by: Vasiliy Kulikov<segoon@openwall.com>
[...]

> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> index 77ecebf..871bca9 100644
> --- a/arch/arm/mach-omap2/smartreflex.c
> +++ b/arch/arm/mach-omap2/smartreflex.c
> @@ -260,7 +260,10 @@ static int sr_late_init(struct omap_sr *sr_info)
>   	if (sr_class->class_type == SR_CLASS2&&
>   		sr_class->notify_flags&&  sr_info->irq) {
>
> +		ret = -ENOMEM;
>   		name = kzalloc(SMARTREFLEX_NAME_LEN + 1, GFP_KERNEL);
> +		if (name == NULL)
> +			goto error;

    Why not:

		if (name == NULL) {
			ret = -ENOMEM;
			goto error;
		}

WBR, Sergei
