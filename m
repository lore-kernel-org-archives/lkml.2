Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1C3TcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:32:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44530 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab1C3TcN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 30 Mar 2011 15:32:13 -0400
Date: Wed, 30 Mar 2011 15:31:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Nicolas Kaiser <nikai@nikai.net>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: events: fix error checks in bind_*_to_irqhandler()
Message-ID: <20110330193136.GA19522@dumpdata.com>
References: <20110330211426.13f182d6@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330211426.13f182d6@absol.kitzblitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D938516.0095,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 09:14:26PM +0200, Nicolas Kaiser wrote:
> Checking 'irq < 0' doesn't work when 'irq' is unsigned.
> 
> The assigned bind_evtchn_to_irq() and bind_virq_to_irq()
> return int, so using int appears appropriate.

Whoops. Good check. Will have it queue up for rc2.

Will fix up the bind_virq_to_irqhandler case as well.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  drivers/xen/events.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 036343b..589f0a5 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -912,8 +912,7 @@ int bind_evtchn_to_irqhandler(unsigned int evtchn,
>  			      unsigned long irqflags,
>  			      const char *devname, void *dev_id)
>  {
> -	unsigned int irq;
> -	int retval;
> +	int irq, retval;
>  
>  	irq = bind_evtchn_to_irq(evtchn);
>  	if (irq < 0)
> @@ -955,8 +954,7 @@ int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
>  			    irq_handler_t handler,
>  			    unsigned long irqflags, const char *devname, void *dev_id)
>  {
> -	unsigned int irq;
> -	int retval;
> +	int irq, retval;
>  
>  	irq = bind_virq_to_irq(virq, cpu);
>  	if (irq < 0)
> -- 
> 1.7.3.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
