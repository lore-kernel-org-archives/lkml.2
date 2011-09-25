Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1IYQPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 12:15:15 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:38415 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1IYQPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 12:15:13 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Jyrki Kuoppala <jkp@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Fix to qt1010 tuner frequency selection (media/dvb)
Date: Sun, 25 Sep 2011 17:13:06 +0100
Message-ID: <5010154.A6jI82beuA@valkyrie>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc7cc+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E528FAE.5060801@iki.fi>
References: <4E528FAE.5060801@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 Aug 2011 20:19:42 Jyrki Kuoppala wrote:
> The patch fixes frequency selection for some UHF frequencies e.g.
> channel 32 (562 MHz) on the qt1010 tuner. The tuner is used e.g. in the
> MSI Mega Sky dvb-t stick ("MSI Mega Sky 55801 DVB-T USB2.0")
> 
> One example of problem reports of the bug this fixes can be read at
> http://www.freak-search.com/de/thread/330303/linux-dvb_tuning_problem_with_s
> ome_frequencies_qt1010,_dvb
> 
> Applies to kernel versions 2.6.38.8, 2.6.39.4, 3.0.3 and 3.1-rc2.
> 
> Signed-off-by: Jyrki Kuoppala <jkp@iki.fi>

Cc: stable@kernel.org
Tested-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

This patch means I can now finally tune to all the BBC channels (which are on 
channel 31 (554 MHz) in my area). This should definitely go to stable, as I've 
also seen other similar reports for users who can't tune to various channels 
in the affected ranges here using qt1010.

Mauro - I don't see this one in your git tree in the 3.2 branch, or in the 
temporary linuxtv patchwork, so I'm assuming this one fell between the cracks?

-Carlos

> diff -upr linux-source-2.6.38.orig/drivers/media/common/tuners/qt1010.c
> linux-source-2.6.38/drivers/media/common/tuners/qt1010.c
> --- linux-source-2.6.38.orig/drivers/media/common/tuners/qt1010.c
> 2011-03-15 03:20:32.000000000 +0200
> +++ linux-source-2.6.38/drivers/media/common/tuners/qt1010.c
> 2011-08-21 23:16:38.209580365 +0300
> @@ -198,9 +198,10 @@ static int qt1010_set_params(struct dvb_
> 
>       /* 22 */
>       if      (freq < 450000000) rd[15].val = 0xd0; /* 450 MHz */
> -    else if (freq < 482000000) rd[15].val = 0xd1; /* 482 MHz */
> +    else if (freq < 482000000) rd[15].val = 0xd2; /* 482 MHz */
>       else if (freq < 514000000) rd[15].val = 0xd4; /* 514 MHz */
> -    else if (freq < 546000000) rd[15].val = 0xd7; /* 546 MHz */
> +    else if (freq < 546000000) rd[15].val = 0xd6; /* 546 MHz */
> +    else if (freq < 578000000) rd[15].val = 0xd8; /* 578 MHz */
>       else if (freq < 610000000) rd[15].val = 0xda; /* 610 MHz */
>       else                       rd[15].val = 0xd0;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
