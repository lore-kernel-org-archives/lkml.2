Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1HOO42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:56:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42318 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab1HOO40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:56:26 -0400
MIME-Version: 1.0
In-Reply-To: <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de> <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 15 Aug 2011 08:56:05 -0600
X-Google-Sender-Auth: LXLbWBHuNaxa_OGgOyeiktmsMoI
Message-ID: <CACxGe6us1vaUgMmiZR-D9iSCQdw+vbVyZdBCkET_9p3AGyHwRQ@mail.gmail.com>
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for uevent
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 8:51 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> If id_entry is available then it is used. However if we remove first the
> driver followed by the device, then the id_entry is pointing to driver's
> memory which is long gone.
> Since id->name and plat->name are equal there is no point in
> distinguishing them.
>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/base/platform.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 0cad9c7..cd71575 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -614,7 +614,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
>                return rc;
>
>        add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
> -               (pdev->id_entry) ? pdev->id_entry->name : pdev->name);
> +                       pdev->name);

Yes, this looks like the right thing to do to me.  Also, I think the
original code is suspect because it causes the uevent data to be
different after binding a driver to a device.

g.
