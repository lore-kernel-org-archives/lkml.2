Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab1CYKEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:04:09 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16594 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1CYKEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:04:07 -0400
X-IronPort-AV: E=Sophos;i="4.63,242,1299474000"; 
   d="scan'208";a="13314062"
Subject: Re: [PATCH] xen: Use new irq_move functions
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
In-Reply-To: <alpine.LFD.2.00.1103242135380.31464@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103242135380.31464@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 25 Mar 2011 10:04:02 +0000
Message-ID: <1301047442.11560.194.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 20:37 +0000, Thomas Gleixner wrote:
> These functions take irq_data as an argument and avoid a redundant
> lookup in the sparse irq case.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Looks good to me.

Acked-by: Ian Campbell <ian.campbell@citrix.com>

Do you want to carry this in your tree or shall we pick it up? (not sure
if this is part of a wider treewide series or not)

> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/events.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-tip/drivers/xen/events.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/xen/events.c
> +++ linux-2.6-tip/drivers/xen/events.c
> @@ -585,7 +585,7 @@ static void ack_pirq(struct irq_data *da
>  {
>  	int evtchn = evtchn_from_irq(data->irq);
>  
> -	move_native_irq(data->irq);
> +	irq_move_irq(data);
>  
>  	if (VALID_EVTCHN(evtchn)) {
>  		mask_evtchn(evtchn);
> @@ -1339,7 +1339,7 @@ static void ack_dynirq(struct irq_data *
>  {
>  	int evtchn = evtchn_from_irq(data->irq);
>  
> -	move_masked_irq(data->irq);
> +	irq_move_masked_irq(data);
>  
>  	if (VALID_EVTCHN(evtchn))
>  		unmask_evtchn(evtchn);


