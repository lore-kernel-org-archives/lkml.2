Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0EQUzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:55:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311Ab0EQUzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:55:31 -0400
Date: Mon, 17 May 2010 13:52:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg@redhat.com>
cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] input: Default to only using PNP for i8042 probing
 on x86
In-Reply-To: <1274110716-12488-3-git-send-email-mjg@redhat.com>
Message-ID: <alpine.LFD.2.00.1005171352010.4195@i5.linux-foundation.org>
References: <1274110716-12488-1-git-send-email-mjg@redhat.com> <1274110716-12488-3-git-send-email-mjg@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Matthew Garrett wrote:
> @@ -744,9 +746,10 @@ static int __init i8042_pnp_init(void)
>  
>  	if (!i8042_pnp_kbd_devices && !i8042_pnp_aux_devices) {
>  		i8042_pnp_exit();
> -#if defined(__ia64__)
> -		return -ENODEV;
> -#else
> +
> +		if (!acpi_disabled)
> +			return -ENODEV;
> +
>  		printk(KERN_INFO "PNP: No PS/2 controller found. Probing ports directly.\n");
>  		return 0;
>  #endif

This can't be right. That #endif is still there. How could this even 
compile?

Tssk, tssk.

		Linus
