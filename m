Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab1COQif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:38:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23984 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab1COQie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:38:34 -0400
Date: Tue, 15 Mar 2011 09:37:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Corey Minyard <minyard@acm.org>, Grant Likely <grant.likely@secretlab.ca>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: Re: [PATCH] char/ipmi: fix cleanup_one_si section mismatch
Message-Id: <20110315093756.04c40840.randy.dunlap@oracle.com>
In-Reply-To: <20110215095245.GB4350@swordfish.minsk.epam.com>
References: <20110214150310.GA4350@swordfish.minsk.epam.com>
	<4D59BAED.9060501@acm.org>
	<20110215095245.GB4350@swordfish.minsk.epam.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D7F95EB.0155,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011 11:52:45 +0200 Sergey Senozhatsky wrote:

> 
> commit d2478521afc20227658a10a8c5c2bf1a2aa615b3
> Author: Corey Minyard<minyard@acm.org>
> Date:   Thu Feb 10 16:08:38 2011 -0600
> 
>      char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver
> 
> 
> Introduced section mismatch by calling __exit cleanup_ipmi_si from __devinit 
> init_ipmi_si. Remove __exit annotation from cleanup_ipmi_si.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Acked-by: Corey Minyard <cminyard@mvista.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
> 
>  drivers/char/ipmi/ipmi_si_intf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 7855f9f..94cd2ce 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -3532,7 +3532,7 @@ static void cleanup_one_si(struct smi_info *to_clean)
>  	kfree(to_clean);
>  }
>  
> -static void __exit cleanup_ipmi_si(void)
> +static void cleanup_ipmi_si(void)
>  {
>  	struct smi_info *e, *tmp_e;
>  
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
