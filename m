Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1KLSJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 13:09:35 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47999 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1KLSJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 13:09:34 -0500
Message-ID: <4EBEB65A.9040704@mvista.com>
Date: Sat, 12 Nov 2011 20:09:30 +0200
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: OHCI/EHCI-XLS: Use resource_size v2
References: <1320948556.20155.23.camel@localhost.localdomain>
In-Reply-To: <1320948556.20155.23.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10.11.2011 20:09, Thomas Meyer wrote:

> Use resource_size function on resource object
> instead of explicit computation.
>
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/resource_size.cocci.
>
> Signed-off-by: Thomas Meyer<thomas@m3y3r.de>
> ---
[...]
> diff -u -p a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
> --- a/arch/hexagon/kernel/time.c 2011-11-07 19:37:21.719553477 +0100
> +++ b/arch/hexagon/kernel/time.c 2011-11-08 12:21:17.722176538 +0100
> @@ -200,12 +200,10 @@ void __init time_init_deferred(void)
>   		resource = rtos_timer_device.resource;
>
>   	/*  ioremap here means this has to run later, after paging init  */
> -	rtos_timer = ioremap(resource->start, resource->end
> -		- resource->start + 1);
> +	rtos_timer = ioremap(resource->start, resource_size(resource));
>
>   	if (!rtos_timer) {
> -		release_mem_region(resource->start, resource->end
> -			- resource->start + 1);
> +		release_mem_region(resource->start, resource_size(resource));
>   	}
>   	clocksource_register_khz(&hexagon_clocksource, pcycle_freq_mhz * 1000);


    I don't think this file belongs to the USB specific patch.

WBR, Sergei

