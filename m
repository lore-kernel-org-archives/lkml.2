Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1HBRR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:17:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45451 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1HBRRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:17:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110802145237.e8b90cff7f6954f6a12d8b3b@canb.auug.org.au>
References: <20110802145237.e8b90cff7f6954f6a12d8b3b@canb.auug.org.au>
Date: Tue, 2 Aug 2011 13:17:49 -0400
X-Google-Sender-Auth: GUQkPU-w6k3pbZ3vQocb_YdB5UU
Message-ID: <CAP=VYLq5p0KD5QW-Ae3=MQojcBSGdngbVwbCC_iyh_VzkPkxGA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the moduleh tree with Linus' tree
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 12:52 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Paul,
>
> Today's linux-next merge of the moduleh tree got a conflict in
> drivers/video/omap2/dss/rfbi.c between commit 24e6289c029b ("OMAP: DSS2:
> remove extra includes from include/video/omapdss.h") from Linus' tree and
> commit 06e632e042aa ("video: Add export.h for THIS_MODULE/EXPORT_SYMBOL
> to drivers/video") from the moduleh tree.
>
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

I was making some cosmetic changes to commit logs (such as adding Acked-by
etc) and so took the opportunity to just relocate the export.h
addition up higher
and out of the way, which should make this go away for you/Linus.

Thanks for the heads up,
Paul.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/video/omap2/dss/rfbi.c
> index 39f4c59,5dbd229..0000000
> --- a/drivers/video/omap2/dss/rfbi.c
> +++ b/drivers/video/omap2/dss/rfbi.c
> @@@ -33,8 -33,7 +33,9 @@@
>  #include <linux/hrtimer.h>
>  #include <linux/seq_file.h>
>  #include <linux/semaphore.h>
>  +#include <linux/platform_device.h>
>  +#include <linux/pm_runtime.h>
> + #include <linux/export.h>
>
>  #include <video/omapdss.h>
>  #include "dss.h"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
