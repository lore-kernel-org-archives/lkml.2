Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab1I3Hz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:55:56 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:1513 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab1I3Hzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:55:55 -0400
X-IronPort-AV: E=Sophos;i="4.68,465,1312156800"; 
   d="scan'208";a="8142765"
Subject: Re: [Xen-devel] [PATCH 4/9] xen/events: BUG() when we can't
 allocate our event->irq array.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dan Carpenter <error27@gmail.com>
Date: Fri, 30 Sep 2011 08:55:53 +0100
In-Reply-To: <1317325971-21603-5-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
	 <1317325971-21603-5-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317369353.26672.215.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 20:52 +0100, Konrad Rzeszutek Wilk wrote:
> In case we can't allocate we are doomed. We should BUG_ON
> instead of trying to dereference it later on.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/events.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 7523719..5db04bf 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -1670,6 +1670,8 @@ void __init xen_init_IRQ(void)
>  
>  	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
>  				    GFP_KERNEL);
> +	if (!evtchn_to_irq)
> +		BUG();

AKA
	BUG_ON(!evtchn_to_irq);

but

Acked-by: Ian Campbell <ian.campbell@citrix.com>


