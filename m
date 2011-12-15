Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731Ab1LOXEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:04:13 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39018 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756576Ab1LOXEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:04:10 -0500
X-Sasl-enc: p7wkvJiDZwZK1z7o2zqpN7WAdDrecKFchdMeOUxqor2i 1323990249
Date: Thu, 15 Dec 2011 15:02:25 -0800
From: Greg KH <greg@kroah.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: musb: fix pm_runtime mismatch
Message-ID: <20111215230225.GB26893@kroah.com>
References: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 12:42:14AM +0200, Felipe Contreras wrote:
> In musb_init_controller() there's a pm_runtime_put(), but there's no
> pm_runtime_get(), which creates a mismatch that causes the driver to
> sleep when it shouldn't.
> 
> This was introduced in 7acc619, but it wasn't triggered until 18a2689
> was merged to Linus' branch at point 6899608.
> 
> However, it seems most of the time this is used in a way that keeps the
> counter above 0, so nobody noticed. Also, it seems to depend on the
> configuration used.
> 
> I found the problem by loading isp1704_charger before any usb gadgets:
> http://article.gmane.org/gmane.linux.kernel/1226122
> 
> All versions after 2.6.39 are affected.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  drivers/usb/musb/musb_core.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

Will you be including this in your next pull request for me to include
in my tree to go to Linus soon?

thanks,

greg k-h
