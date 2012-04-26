Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2DZKON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:14:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10372 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab2DZKOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:14:12 -0400
X-IronPort-AV: E=Sophos;i="4.75,485,1330923600"; 
   d="scan'208";a="24562726"
Message-ID: <4F991FF1.6000007@citrix.com>
Date: Thu, 26 Apr 2012 11:14:09 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xen.org>, <tobias.geiger@vido.info>,
        <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: use the pirq number to check the	pirq_eoi_map
References: <1335366698-19875-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1335366698-19875-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/12 16:11, Stefano Stabellini wrote:
> In pirq_check_eoi_map use the pirq number rather than the Linux irq
> number to check whether an eoi is needed in the pirq_eoi_map.

What buggy behaviour does this patch fix?  It would be nice if this was
included in the patch description.

David

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Tested-by: Tobias Geiger <tobias.geiger@vido.info>
> ---
>  drivers/xen/events.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 4b33acd..0a8a17c 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -274,7 +274,7 @@ static unsigned int cpu_from_evtchn(unsigned int evtchn)
>  
>  static bool pirq_check_eoi_map(unsigned irq)
>  {
> -	return test_bit(irq, pirq_eoi_map);
> +	return test_bit(pirq_from_irq(irq), pirq_eoi_map);
>  }
>  
>  static bool pirq_needs_eoi_flag(unsigned irq)

