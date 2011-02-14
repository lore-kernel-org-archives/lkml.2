Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1BNXaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:30:13 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:46930 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1BNXaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:30:11 -0500
Message-id: <4D59BAED.9060501@acm.org>
Date: Mon, 14 Feb 2011 17:29:49 -0600
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13)
 Gecko/20101208 Thunderbird/3.1.7
MIME-version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: char/ipmi: cleanup_one_si section mismatch
References: <20110214150310.GA4350@swordfish.minsk.epam.com>
In-reply-to: <20110214150310.GA4350@swordfish.minsk.epam.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, I should have noticed this.

Acked-by: Corey Minyard <cminyard@mvista.com>

On 02/14/2011 09:03 AM, Sergey Senozhatsky wrote:
> Hello,
>
> commit d2478521afc20227658a10a8c5c2bf1a2aa615b3
> Author: Corey Minyard<minyard@acm.org>
> Date:   Thu Feb 10 16:08:38 2011 -0600
>
>      char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver
>
>
> Introduced section mismatch by calling __exit cleanup_ipmi_si
> from __devinit init_ipmi_si. Should we remove __exit annotation then?
>
>
> ---
>
>   drivers/char/ipmi/ipmi_si_intf.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 7855f9f..94cd2ce 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -3532,7 +3532,7 @@ static void cleanup_one_si(struct smi_info *to_clean)
>   	kfree(to_clean);
>   }
>
> -static void __exit cleanup_ipmi_si(void)
> +static void cleanup_ipmi_si(void)
>   {
>   	struct smi_info *e, *tmp_e;
>
>

