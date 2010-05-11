Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab0EKRTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:19:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47592 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab0EKRTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kiqx9zoWMy8atjjI1qJs4b49RY07mzRxjpAJdZzvQAexRMDfQCdrRYAct7EFCjkFMS
         s+RLRl+CRUxmC1tITOji2kuOBfuAHGLpS5PlyXaiMTYjcYuNZdz+6aPxvNlHc/McXmdk
         Lf+xstxcHbHwuC+DQyQpkQPD1DeXqua9txLWE=
Date: Tue, 11 May 2010 21:19:24 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Matt Reimer <mreimer@vpop.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Tejun Heo <tj@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3/3] power/ds2760_battery: use factor of 20 for
 rated_capacity
Message-ID: <20100511171924.GA19428@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <1273595926-26249-3-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1273595926-26249-3-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 06:38:46PM +0200, Daniel Mack wrote:
> In the ds2760 driver, the currently used factor of 10 to store the rated
> battery capacity internally is not sufficient for batteries > 2.55 Ah,
> as the 8-bit register will overflow for bigger values.
> 
> Change the factor to 20 to broaden that range. Note that due to
> RATED_CAPACITY_FACTOR, the external interface won't change, neither for
> the writeable sysfs entires nor for the kernel rated_capacity module
> parameter.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
> Cc: Matt Reimer <mreimer@vpop.net>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Hi Daniel,

Sorry, it took quite a bit to get to your patches.

They look good (as usual), but I have a few concerns.

>  drivers/power/ds2760_battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
> index b82bf92..7b3043f 100644
> --- a/drivers/power/ds2760_battery.c
> +++ b/drivers/power/ds2760_battery.c
> @@ -78,7 +78,7 @@ MODULE_PARM_DESC(current_accum, "current accumulator value");
>  
>  /* Some batteries have their rated capacity stored a N * 10 mAh, while
>   * others use an index into this table. */
> -#define RATED_CAPACITY_FACTOR 10
> +#define RATED_CAPACITY_FACTOR 20

I'm a bit worried about this one.

Shouldn't this confuse batteries that already store rated
capacity with factor of ten? If so, please introduce a module
option.

Also, you don't update comments and module params description,
e.g.

  MODULE_PARM_DESC(rated_capacity, "rated battery capacity, 10*mAh or index");
  ....
  /* set rated capacity from module param (given in 10 * mAh) */

Is that intentionally?

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
