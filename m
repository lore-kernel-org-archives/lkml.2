Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0IMIzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:55:33 -0400
Received: from smtp.nokia.com ([192.100.105.134]:54176 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0IMIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:55:32 -0400
Subject: Re: [patch] mtd: sanity check input
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Dan Carpenter <error27@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
In-Reply-To: <20100908193956.GB3463@bicker>
References: <20100908193956.GB3463@bicker>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 13 Sep 2010 11:53:43 +0300
Message-ID: <1284368023.27765.179.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Sep 2010 08:55:10.0188 (UTC) FILETIME=[5EEE1AC0:01CB5321]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 21:39 +0200, Dan Carpenter wrote:
> If "ur_idx" is wrong we could go past the end of the array.  The
> "ur_idx" comes from root so it's not a huge deal, but adding a sanity
> check makes the code more robust.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index a825002..9c00549 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -513,6 +513,9 @@ static int mtd_ioctl(struct file *file, u_int cmd, u_long arg)
>  		if (get_user(ur_idx, &(ur->regionindex)))
>  			return -EFAULT;
>  
> +		if (ur_idx >= mtd->numeraseregions)
> +			return -EINVAL;
> +

Pushed to l2-mtd-2.6.git with my "Signed-off-by", thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

