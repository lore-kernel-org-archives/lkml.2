Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab1CJFjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:39:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60857 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1CJFjj (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Mar 2011 00:39:39 -0500
Date: Thu, 10 Mar 2011 00:38:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 14/14] xen: events: propagate irq allocation failure
 instead of panicking
Message-ID: <20110310053852.GE10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
 <1299692486-28634-14-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299692486-28634-14-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D786414.0050,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:41:26PM +0000, Ian Campbell wrote:
> Running out of IRQs need not be fatal to the machine as a whole.

Do the backends/frontends deal with this appropiately?
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  drivers/xen/events.c |   22 ++++++++++++++--------
>  1 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 51c6a5b..c6f2a2e 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -406,7 +406,7 @@ static void xen_irq_init(unsigned irq)
>  	list_add_tail(&info->list, &xen_irq_list_head);
>  }
>  
> -static int xen_allocate_irq_dynamic(void)
> +static int __must_check xen_allocate_irq_dynamic(void)

What is the '__must_check' for?

