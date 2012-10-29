Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761014Ab2J2V2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:28:19 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:34782 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053Ab2J2V2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:28:17 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av2eAJzzjlBV5h1yPGdsb2JhbABEilK0Y4JEAgKBCBkBAQEBODSCHgEBBAEnExwjEAgDRhQlChqIEwq8AxSMF4EmgieBeWEDlXOFeY0sDg
X-IronPort-AV: E=Sophos;i="4.80,675,1344204000"; 
   d="scan'208";a="219475058"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 29 Oct 2012 22:32:54 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Input: introduce managed input devices (add devres
 support)
Message-ID: <20121029213254.GA15390@polaris.bitmath.org>
References: <20121023053513.GA15642@core.coreip.homeip.net>
 <20121029182253.GA8015@polaris.bitmath.org>
 <20121029185919.GA13256@core.coreip.homeip.net>
 <20121029200226.GA15156@polaris.bitmath.org>
 <20121029204023.GB13256@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029204023.GB13256@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Either way, the code looks functional to me.
> 
> So is that "reviewed-by"?

I was thinking about this hunk:

> @@ -1972,7 +2084,20 @@ int input_register_device(struct input_dev *dev)
> 
>         mutex_unlock(&input_mutex);
> 
> +       if (dev->devres_managed) {
> +               dev_info(dev->dev.parent, "%s: registerign %s with devres.\n",
> +                       __func__, dev->name ?: "N/A");
> +               devres_add(dev->dev.parent, devres);
> +       }
>         return 0;
> +                                     
> +err_device_del:
> +       device_del(&dev->dev);
> +err_free_vals:
> +       kfree(dev->vals);

Won't this yield a double free once we reach release()?

> +err_devres_free:
> +       devres_free(devres);
>  +       return error;
>  }
>  EXPORT_SYMBOL(input_register_device);

Thanks,
Henrik
