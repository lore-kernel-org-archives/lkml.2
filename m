Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1IFE4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 00:56:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39919 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1IFE4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 00:56:35 -0400
Subject: Re: [PATCH] document ubiblk's usage of the same ioctl magic as a
 part of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 06 Sep 2011 07:58:50 +0300
In-Reply-To: <1314202916-6982-1-git-send-email-david.wagner@free-electrons.com>
References: <1314202540-5562-1-git-send-email-david.wagner@free-electrons.com>
	 <1314202916-6982-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315285135.19067.59.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 18:21 +0200, David Wagner wrote:
> ---
>  include/mtd/ubi-user.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
> index 3c41097..7c8bfe3 100644
> --- a/include/mtd/ubi-user.h
> +++ b/include/mtd/ubi-user.h
> @@ -188,6 +188,7 @@
>  /* Set an UBI volume property */
>  #define UBI_IOCSETVOLPROP _IOW(UBI_VOL_IOC_MAGIC, 6, \
>  			       struct ubi_set_vol_prop_req)
> +/* If you add ioctls here, please note that ubiblk uses 'O'/0x10-0x11 */
>  
>  /* Maximum MTD device name length supported by UBI */
>  #define MAX_UBI_MTD_NAME_LEN 127

Let's postpone this patch and the user-space tool until ubiblk is ready
for inclusion. I sent you some comments - the main one is the block
device reference counting and making sure that the underlying UBI volume
does not disappear when you use it.

-- 
Best Regards,
Artem Bityutskiy

