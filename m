Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0DEVLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:11:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46536 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412Ab0DEVLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:11:39 -0400
Message-ID: <4BBA51F3.7070808@zytor.com>
Date: Mon, 05 Apr 2010 14:11:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mingo@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if CONFIG_VGA_CONSOLE
 is undefined
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>	 <1270491029.1477.453.camel@groeck-laptop>  <4BBA3021.9090504@zytor.com>	 <1270497725.1477.488.camel@groeck-laptop>  <4BBA473D.9040004@zytor.com> <1270501481.1477.521.camel@groeck-laptop>
In-Reply-To: <1270501481.1477.521.camel@groeck-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 02:04 PM, Guenter Roeck wrote:
> 
> Would you accept a minimized patch like this ?
> 
>  /* Direct interface for emergencies */
> +#ifdef CONFIG_VGA_CONSOLE
>  static struct console *early_console = &early_vga_console;
> +#else
> +static struct console *early_console = &early_serial_console;
> +#endif
>  static int __initdata early_console_initialized;
> 
> This would prevent the problem while minimizing changes, and at the same
> time permit early messages to be written to the serial console.
> 

I'm unhappy about it, because *those early messages shouldn't exist in
the first place*.  It seems to be an indication that we're invoking
setup_early_printk() too late.  The whole playing around with max_xpos
and max_ypos instead of using boot_params.screen_info directly is
particularly bleacherous.

I would at least like to see if the improper invocation of
early_printk() can be avoided.

	-hpa
