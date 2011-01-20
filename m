Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1ATMR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:17:58 -0500
Received: from smtp.nokia.com ([147.243.1.48]:45911 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab1ATMR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:17:56 -0500
Subject: Re: [alsa-devel] [PATCH v4 1/3] ECI: input: introduce ECI
 accessory input driver
From: Tapio Vihuri <tapio.vihuri@nokia.com>
Reply-To: tapio.vihuri@nokia.com
To: ext Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: randy.dunlap@oracle.com, alsa-devel@alsa-project.org,
        samu.p.onkalo@nokia.com, peter.ujfalusi@nokia.com,
        linux-kernel@vger.kernel.org, ilkka.koskinen@nokia.com
In-Reply-To: <20110120081117.GB2498@core.coreip.homeip.net>
References: <1295438816-27937-1-git-send-email-tapio.vihuri@nokia.com>
	 <1295438816-27937-2-git-send-email-tapio.vihuri@nokia.com>
	 <20110119174412.GB29107@core.coreip.homeip.net>
	 <1295510248.26257.7.camel@dell>
	 <20110120081117.GB2498@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Thu, 20 Jan 2011 14:17:33 +0200
Message-ID: <1295525853.26257.21.camel@dell>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 00:11 -0800, ext Dmitry Torokhov wrote:
> > How about KE_VSW case ? Shouldn't it be in the sparse_keymap_setup
> {}
> > also ?
> > 
> 
> Indeed. Does the patch below fix it?
> 

Hi.

Yes it does, thank you.

Patch working (as it obviously should) OK in my environment, so


> Thanks.
> 
> -- 
> Dmitry
> 
> Input: sparse-keymap - fix KEY_VSW handling in sparse_keymap_setup
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> We were forgetting to set up device capabilities for KEY_VSW entries.
> 
> Reported-by: Tapio Vihuri <tapio.vihuri@nokia.com> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Tested-by: Tapio Vihuri <tapio.vihuri@nokia.com> 

> ---
> 
>  drivers/input/sparse-keymap.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/input/sparse-keymap.c
> b/drivers/input/sparse-keymap.c
> index a29a7812..7729e54 100644
> --- a/drivers/input/sparse-keymap.c
> +++ b/drivers/input/sparse-keymap.c
> @@ -201,6 +201,7 @@ int sparse_keymap_setup(struct input_dev *dev,
>                         break;
>  
>                 case KE_SW:
> +               case KE_VSW:
>                         __set_bit(EV_SW, dev->evbit);
>                         __set_bit(entry->sw.code, dev->swbit);
>                         break;
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel 
-- 
Tapsa
050 4876788

