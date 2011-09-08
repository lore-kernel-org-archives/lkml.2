Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1IHPaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:30:04 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:55290 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1IHPaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:30:02 -0400
Message-id: <4E68DF5D.1050105@acm.org>
Date: Thu, 08 Sep 2011 10:29:33 -0500
From: Corey Minyard <minyard@acm.org>
Reply-to: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21)
 Gecko/20110831 Thunderbird/3.1.13
MIME-version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Clemens Ladisch <clemens@ladisch.de>,
        Mark Gross <mark.gross@intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>,
        openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 31/62] driver/char: irq: Remove IRQF_DISABLED
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-32-git-send-email-yong.zhang0@gmail.com>
In-reply-to: <1315383059-3673-32-git-send-email-yong.zhang0@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 03:10 AM, Yong Zhang wrote:
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 9397ab4..44e8da3 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -1336,7 +1336,7 @@ static int std_irq_setup(struct smi_info *info)
>   	if (info->si_type == SI_BT) {
>   		rv = request_irq(info->irq,
>   				 si_bt_irq_handler,
> -				 IRQF_SHARED | IRQF_DISABLED,
> +				 IRQF_SHARED,
>   				 DEVICE_NAME,
>   				 info);
>   		if (!rv)
> @@ -1346,7 +1346,7 @@ static int std_irq_setup(struct smi_info *info)
>   	} else
>   		rv = request_irq(info->irq,
>   				 si_irq_handler,
> -				 IRQF_SHARED | IRQF_DISABLED,
> +				 IRQF_SHARED,
>   				 DEVICE_NAME,
>   				 info);
>   	if (rv) {
>
Ok by me.

Acked-by: Corey Minyard <cminyard@mvista.com>
