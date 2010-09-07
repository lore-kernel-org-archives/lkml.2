Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0IGPKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:10:01 -0400
Received: from mail.perches.com ([173.55.12.10]:1500 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab0IGPJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:09:56 -0400
Subject: Re: [PATCH 2/3] Staging: otus: added valid KERN_ loglevels to
 printk in wwrap.c
From: Joe Perches <joe@perches.com>
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, daniele.boncompagni@gmail.com,
        linux-kernel@vger.kernel.org, julia@diku.dk
In-Reply-To: <7e1ccc28be954d553b6daddf54dbc149f27c709f.1283865137.git.pshah.mumbai@gmail.com>
References: <3f9402c47b6c1e56310bc43ea624bae01dce826f.1283865137.git.pshah.mumbai@gmail.com>
	 <7e1ccc28be954d553b6daddf54dbc149f27c709f.1283865137.git.pshah.mumbai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Sep 2010 08:09:53 -0700
Message-ID: <1283872193.23280.123.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 18:44 +0530, Prashant P. Shah wrote:
> This is a patch to the wwrap.c file that adds valid KERN_ loglevels
> to printk() statements
> 
> Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
> ---
>  drivers/staging/otus/wwrap.c |   33 ++++++++++++++++-----------------
>  1 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
[]
> @@ -358,13 +357,13 @@ void zfLnxUsbDataIn_callback(urb_t *urb)
>  #if 0
>  			/* Dump data */
>  			for (ii = index; ii < pkt_len+4;) {
> -				printk("%02x ", (buf->data[ii] & 0xff));
> +				printk(KERN_INFO "%02x ", (buf->data[ii] & 0xff));
>  
>  				if ((++ii % 16) == 0)
> -					printk("\n");
> +					printk(KERN_INFO "\n");
>  			}
>  
> -			printk("\n");
> +			printk(KERN_INFO "\n");
>  #endif
>  
>  			pad_len = 4 - (pkt_len & 0x3);

and

> @@ -636,11 +635,11 @@ u32_t zfLnxUsbSubmitTxData(zdev_t *dev)
>  	if (TxData->hdrlen != 0) {
>  		puTxBuf = macp->txUsbBuf[freeTxUrb];
>  		for (i = 0; i < len; i++) {
> -			printk("%02x ", puTxBuf[i]);
> +			printk(KERN_INFO "%02x ", puTxBuf[i]);
>  			if (i % 16 == 15)
> -				printk("\n");
> +				printk(KERN_INFO "\n");
>  		}
> -		printk("\n");
> +		printk(KERN_INFO "\n");

These should use KERN_CONT.

It'd be better to use print_hex_dump() instead.


