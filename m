Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0KVJbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 04:31:20 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:60240 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab0KVJbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 04:31:19 -0500
Message-ID: <4CEA32F1.2030208@atmel.com>
Date: Mon, 22 Nov 2010 10:08:01 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [35/45] USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request
 failled
References: <20101119214412.310478722@clark.site>
In-Reply-To: <20101119214412.310478722@clark.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 19/11/2010 22:43, Greg KH :
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.

Hi Greg,

Please also add this typo one (or merge it): 

http://git.kernel.org/?p=linux/kernel/git/gregkh/usb-2.6.git;a=commit;h=b48809518631880207796b4aab0fc39c2f036754

Thanks a lot for monitoring this issue and adding to -stable...

Best regards,
 
> ------------------
> 
> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> commit 969affff54702785330de553b790372e261e93f9 upstream.
> 
> to ensure gpio_is_valid return false
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/usb/gadget/atmel_usba_udc.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -2013,6 +2013,9 @@ static int __init usba_udc_probe(struct
>  			} else {
>  				disable_irq(gpio_to_irq(udc->vbus_pin));
>  			}
> +		} else {
> +			/* gpio_request fail so use -EINVAL for gpio_is_valid */
> +			ubc->vbus_pin = -EINVAL;
>  		}
>  	}
>  
> 
> 
> 


-- 
Nicolas Ferre

