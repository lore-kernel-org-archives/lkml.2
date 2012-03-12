Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2CLB0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:26:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44766 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2CLB0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:26:01 -0400
MIME-Version: 1.0
In-Reply-To: <4F5D4E02.4080209@gmail.com>
References: <4F5D4E02.4080209@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 12 Mar 2012 12:25:40 +1100
Message-ID: <CAGRGNgUufVtfdX6D=LPmWXGL=O_x-uBRUWNNyKt1enMEPhGH4w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mac80211: improve PID rate control mechanism by
 avoiding rate oscillation problem
To: wei <yinwei168@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

Again, a couple of minor comments.

On Mon, Mar 12, 2012 at 12:14, wei <yinwei168@gmail.com> wrote:
> From Wei YIN <Wei.Yin@nicta.com.au>
> Improve PID rate control mechanism by avoiding rate oscillation problem
>
> Signed-off-by: Wei YIN <Wei.Yin@nicta.com.au>
> ---
> kernel 3.3.0
> net/mac80211/rc80211_pid_debugfs.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
> 1 file changed, 65 insertions(+), 6 deletions(-)
>
> --- wireless-testing_orig/net/mac80211/rc80211_pid_debugfs.c    2012-02-17 13:59:53.487182968 +1000
> +++ wireless-testing/net/mac80211/rc80211_pid_debugfs.c 2012-03-08 14:45:38.727184486 +1000
> @@ -1,5 +1,6 @@
>  /*
>  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
> + * Copyright 2012, Wei Yin, National ICT Australia <Wei.Yin@nicta.com.au>
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License version 2 as
> @@ -13,12 +14,72 @@
>  #include <linux/types.h>
>  #include <linux/skbuff.h>
>  #include <linux/slab.h>
> -#include <linux/export.h>

This change should go in a separate patch.

>  #include <net/mac80211.h>
>  #include "rate.h"
>
>  #include "rc80211_pid.h"
> +#include <linux/debugfs.h>
> +#include <linux/ieee80211.h>
> +#include <linux/slab.h>
> +#include <linux/export.h>

Different types of includes should be grouped together, the #include
<linux/*> lines should go with their fellows at the top.

Overall, this is significantly improved over your first patch. Well Done.

Does anyone else have any comments about this?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
