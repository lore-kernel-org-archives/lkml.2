Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab2KEPVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:21:40 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61000 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab2KEPVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:21:38 -0500
Message-ID: <5097D97E.80203@gmail.com>
Date: Mon, 05 Nov 2012 16:21:34 +0100
From: Stefan Koch <stefan.koch10@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111120 Icedove/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: IMX257 framebuffer problem
References: <509430C3.9090401@gmail.com>	<509792FB.1080604@gmail.com> <CAFLxGvx-Q3Ye4obNnVbEbEpG8YwecKxEXU0wg11Q1kDrOA1X9w@mail.gmail.com>
In-Reply-To: <CAFLxGvx-Q3Ye4obNnVbEbEpG8YwecKxEXU0wg11Q1kDrOA1X9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I add "video=imxfb:SVGA-16@60" to kernel command line, then there are 
new messages when init fb within BSP file:

Division by zero in kernel.
[<80019ba4>] (unwind_backtrace+0x0/0xf4) from [<8022accc>] (Ldiv0+0x8/0x10)
[<8022accc>] (Ldiv0+0x8/0x10) from [<8022ac9c>] (__aeabi_uidivmod+0x8/0x18)
[<8022ac9c>] (__aeabi_uidivmod+0x8/0x18) from [<80254198>] 
(cfb_imageblit+0x1fc/0x4b0)
[<80254198>] (cfb_imageblit+0x1fc/0x4b0) from [<80251c94>] 
(soft_cursor+0x158/0x1bc)
[<80251c94>] (soft_cursor+0x158/0x1bc) from [<80251664>] 
(bit_cursor+0x4ac/0x4c8)
[<80251664>] (bit_cursor+0x4ac/0x4c8) from [<8024bcd8>] 
(fb_flashcursor+0x108/0x124)
[<8024bcd8>] (fb_flashcursor+0x108/0x124) from [<8003cc00>] 
(process_one_work+0x188/0x4fc)
[<8003cc00>] (process_one_work+0x188/0x4fc) from [<8003d458>] 
(worker_thread+0x130/0x598)
[<8003d458>] (worker_thread+0x130/0x598) from [<80043ef0>] 
(kthread+0x8c/0x98)
[<80043ef0>] (kthread+0x8c/0x98) from [<80015268>] 
(kernel_thread_exit+0x0/0x8)
Division by zero in kernel.
[<80019ba4>] (unwind_backtrace+0x0/0xf4) from [<8022accc>] (Ldiv0+0x8/0x10)
[<8022accc>] (Ldiv0+0x8/0x10) from [<8022ac9c>] (__aeabi_uidivmod+0x8/0x18)
[<8022ac9c>] (__aeabi_uidivmod+0x8/0x18) from [<80254198>] 
(cfb_imageblit+0x1fc/0x4b0)
[<80254198>] (cfb_imageblit+0x1fc/0x4b0) from [<80251c94>] 
(soft_cursor+0x158/0x1bc)
[<80251c94>] (soft_cursor+0x158/0x1bc) from [<80251664>] 
(bit_cursor+0x4ac/0x4c8)
[<80251664>] (bit_cursor+0x4ac/0x4c8) from [<8024bcd8>] 
(fb_flashcursor+0x108/0x124)
[<8024bcd8>] (fb_flashcursor+0x108/0x124) from [<8003cc00>] 
(process_one_work+0x188/0x4fc)
[<8003cc00>] (process_one_work+0x188/0x4fc) from [<8003d458>] 
(worker_thread+0x130/0x598)
[<8003d458>] (worker_thread+0x130/0x598) from [<80043ef0>] 
(kthread+0x8c/0x98)
[<80043ef0>] (kthread+0x8c/0x98) from [<80015268>] 
(kernel_thread_exit+0x0/0x8)
Division by zero in kernel.

Without this command line parameter the "cpsr: 0xffffffff pc: 
0xfffffff9" error still occurs.

The boot works fine when I add the fb_init as you suggested in the 
main.c from kernel.
But I have no /dev/fb0 device. And there are no messages about 
framebuffer in dmesg.

Thanks

Am 05.11.2012 11:43, schrieb richard -rw- weinberger:
> On Mon, Nov 5, 2012 at 11:20 AM, Stefan Koch<stefan.koch10@gmail.com>  wrote:
>>> What could be the problem?
> Find out what exactly is happening after calling add_imx_fb().
> Call it a bit later so that you can see everything on the UART.
> You can hack the call into init/main.c or something else...
>

