Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab0ENACE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:02:04 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:40846 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab0ENACA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:02:00 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201005140001.o4E01R8r029015@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH 16/20] drivers/platform/x86: Use kzalloc
To: julia@diku.dk (Julia Lawall)
Date: Fri, 14 May 2010 09:31:27 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       mjg@redhat.com (Matthew Garrett), platform-driver-x86@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005132206020.6282@ask.diku.dk> from "Julia Lawall" at May 13, 2010 10:06:20 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All good from my POV.

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

> From: Julia Lawall <julia@diku.dk>
> 
> Use kzalloc rather than the combination of kmalloc and memset.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,size,flags;
> statement S;
> @@
> 
> -x = kmalloc(size,flags);
> +x = kzalloc(size,flags);
>  if (x == NULL) S
> -memset(x, 0, size);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/platform/x86/fujitsu-laptop.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff -u -p a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -1090,10 +1090,9 @@ static int __init fujitsu_init(void)
>  	if (acpi_disabled)
>  		return -ENODEV;
>  
> -	fujitsu = kmalloc(sizeof(struct fujitsu_t), GFP_KERNEL);
> +	fujitsu = kzalloc(sizeof(struct fujitsu_t), GFP_KERNEL);
>  	if (!fujitsu)
>  		return -ENOMEM;
> -	memset(fujitsu, 0, sizeof(struct fujitsu_t));
>  	fujitsu->keycode1 = KEY_PROG1;
>  	fujitsu->keycode2 = KEY_PROG2;
>  	fujitsu->keycode3 = KEY_PROG3;
> @@ -1150,12 +1149,11 @@ static int __init fujitsu_init(void)
>  
>  	/* Register hotkey driver */
>  
> -	fujitsu_hotkey = kmalloc(sizeof(struct fujitsu_hotkey_t), GFP_KERNEL);
> +	fujitsu_hotkey = kzalloc(sizeof(struct fujitsu_hotkey_t), GFP_KERNEL);
>  	if (!fujitsu_hotkey) {
>  		ret = -ENOMEM;
>  		goto fail_hotkey;
>  	}
> -	memset(fujitsu_hotkey, 0, sizeof(struct fujitsu_hotkey_t));
>  
>  	result = acpi_bus_register_driver(&acpi_fujitsu_hotkey_driver);
>  	if (result < 0) {
> 
