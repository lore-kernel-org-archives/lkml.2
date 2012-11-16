Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2KPQJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:09:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44966 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2KPQJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:09:36 -0500
Date: Fri, 16 Nov 2012 11:09:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 09/14] xen: events: Remove redundant check on unsigned
 variable
Message-ID: <20121116160923.GP22320@phenom.dumpdata.com>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
 <1353048646-10935-10-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353048646-10935-10-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 12:20:41PM +0530, Tushar Behera wrote:
> No need to check whether unsigned variable is less than 0.
> 
> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> CC: Jeremy Fitzhardinge <jeremy@goop.org>
> CC: xen-devel@lists.xensource.com
> CC: virtualization@lists.linux-foundation.org
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/xen/events.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 4293c57..cadd7d1 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -216,7 +216,7 @@ static void xen_irq_info_pirq_init(unsigned irq,
>   */
>  static unsigned int evtchn_from_irq(unsigned irq)
>  {
> -	if (unlikely(WARN(irq < 0 || irq >= nr_irqs, "Invalid irq %d!\n", irq)))
> +	if (unlikely(WARN(irq >= nr_irqs, "Invalid irq %d!\n", irq)))
>  		return 0;
>  
>  	return info_for_irq(irq)->evtchn;
> -- 
> 1.7.4.1
