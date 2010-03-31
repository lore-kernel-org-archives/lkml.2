Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab0CaScH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:32:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50116 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab0CaScD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:32:03 -0400
Message-ID: <4BB39518.2020200@zytor.com>
Date: Wed, 31 Mar 2010 11:31:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if CONFIG_VGA_CONSOLE
 is undefined
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 07:41 AM, Guenter Roeck wrote:
> Current early_printk code writes into VGA memory space even
> if CONFIG_VGA_CONSOLE is undefined. This can cause problems
> if there is no VGA device in the system, especially if the memory
> is used by another device.
> 
> Fix problem by redirecting output to early_serial_console
> if CONFIG_VGA_CONSOLE is undefined.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
>  
>  asmlinkage void early_printk(const char *fmt, ...)
> @@ -216,7 +224,7 @@ static int __init setup_early_printk(char *buf)
>  			early_serial_init(buf + 4);
>  			early_console_register(&early_serial_console, keep);
>  		}
> -		if (!strncmp(buf, "vga", 3) &&
> +		if (have_vga_console && !strncmp(buf, "vga", 3) &&
>  		    boot_params.screen_info.orig_video_isVGA == 1) {
>  			max_xpos = boot_params.screen_info.orig_video_cols;
>  			max_ypos = boot_params.screen_info.orig_video_lines;

I'm confused in a big way about how you could end up with a system where:

a) there is no VGA;
b) VGA memory is used by another device(!!!);
c) boot_params.screen_info.orig_video_isVGA == 1?

	-hpa
