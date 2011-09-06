Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1IFVIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 17:08:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab1IFVIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 17:08:00 -0400
Date: Tue, 6 Sep 2011 14:07:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: =?ISO-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
        Ilkka Koskinen <ilkka.koskinen@nokia.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] lis3lv02d: Fix read() call in lis3lv02d_get_odr()
Message-Id: <20110906140735.68ddbf42.akpm@linux-foundation.org>
In-Reply-To: <1315293149-3881-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1315293149-3881-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Sep 2011 00:12:28 -0700
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> The driver is passing a struct lis3lv02d ** to the read() operation but
> the read() operation wants a struct lis3lv02d * causing compiler warnings
> and presumably also runtime problems.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@kernel.org
> ---
>  drivers/misc/lis3lv02d/lis3lv02d.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
> index e67dcea..72a1f92 100644
> --- a/drivers/misc/lis3lv02d/lis3lv02d.c
> +++ b/drivers/misc/lis3lv02d/lis3lv02d.c
> @@ -200,7 +200,7 @@ static int lis3lv02d_get_odr(struct lis3lv02d *lis3)
>  	u8 ctrl;
>  	int shift;
>  
> -	lis3->read(&lis3, CTRL_REG1, &ctrl);
> +	lis3->read(lis3, CTRL_REG1, &ctrl);
>  	ctrl &= lis3->odr_mask;
>  	shift = ffs(lis3->odr_mask) - 1;
>  	return lis3->odrs[(ctrl >> shift)];

This not applicable to mainline or to -stable.  It is a fix to
lis3-remove-the-references-to-the-global-variable-in-core-driver.patch
which I already have queued, as
lis3-remove-the-references-to-the-global-variable-in-core-driver-fix.patch.
