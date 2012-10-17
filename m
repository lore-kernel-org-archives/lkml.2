Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2JQPjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:39:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60447 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932203Ab2JQPjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:39:44 -0400
Message-ID: <1350488383.3072.46.camel@joe-AO722>
Subject: Re: [PATCH 3/3] power: wm831x_power.c: Fixed indentation bug and
 whitespace errors
From: Joe Perches <joe@perches.com>
To: Sangho Yi <antiroot@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, cbow@mail.ru, dwmw2@inradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Date: Wed, 17 Oct 2012 08:39:43 -0700
In-Reply-To: <1350486076-3784-3-git-send-email-antiroot@gmail.com>
References: <n> <1350486076-3784-1-git-send-email-antiroot@gmail.com>
	 <1350486076-3784-3-git-send-email-antiroot@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 00:01 +0900, Sangho Yi wrote:
> I removed trailing whitespaces and removed unnecessary whitespaces and
> indentation tabs.
[]
> diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
[]
> @@ -632,9 +632,8 @@ static __devexit int wm831x_power_remove(struct platform_device *pdev)
>  	int irq, i;
>  
>  	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
> -		irq = wm831x_irq(wm831x, 

There is a trailing space here...

> -				 platform_get_irq_byname(pdev,
> -							 wm831x_bat_irqs[i]));

but there's nothing wrong with this.

> +		irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev,
> +			wm831x_bat_irqs[i]));

ugh.

If you're really going to do these sorts of changes
just to minimize overall line length, please keep
arguments aligned on parentheses where appropriate.

Maybe use a temporary if you're really concerned about
overall line length.

	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
		irq = wm831x_irq(wm831x, irq);
	}


