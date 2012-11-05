Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2KEKUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:20:50 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33672 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2KEKUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:20:49 -0500
Message-ID: <509792FB.1080604@gmail.com>
Date: Mon, 05 Nov 2012 11:20:43 +0100
From: Stefan Koch <stefan.koch10@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111120 Icedove/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: IMX257 framebuffer problem
References: <509430C3.9090401@gmail.com>
In-Reply-To: <509430C3.9090401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have moved this message to linux-fbdev mailing list.

Am 02.11.2012 21:44, schrieb Stefan Koch:
> Hi,
>
> I am porting Linux 3.6.2 to a board with Freescale IMX 257 ARM-CPU.
>
> Linux works mostly, kernel can run, and Debian can run with kernel, too.
>
> So I can get access via UART to Debian's Linux console and install 
> packages via apt-get and so on.
>
> So the next step is to enable the graphics support.
>
> The line "imx25_add_imx_fb(&mx25cevipro_fb_pdata);" enables this.
>
> Linux kernel works fine when this line is uncommented, but when it is 
> active kernel stops before print out the first message on serial line.
>
> So openocd prints with general U-Boot kernel boot:
> WARNING: unknown debug reason: 0xf
> ThumbEE -- incomplete support
> target state: halted
> target halted in ThumbEE state due to debug-request, current mode: System
> cpsr: 0xffffffff pc: 0xfffffff9
> MMU: enabled, D-Cache: enabled, I-Cache: enabled
>
> And if I use gdb for loading and step through the source beginning 
> from add_imx_fb(...) line I will get these output from openocd:
>
> Unable to set 32 bit software breakpoint at address 8057c7e0 - check 
> that memory is read/writable
> Unable to set 32 bit software breakpoint at address 8057c7e0 - check 
> that memory is read/writable
> breakpoint not set
> > poll
> background polling: on
> TAP: imx25.cpu (enabled)
> target state: halted
> target halted in ARM state due to breakpoint, current mode: Supervisor
> cpsr: 0x40000013 pc: 0x8057c7e0
> MMU: enabled, D-Cache: enabled, I-Cache: enabled
> > step
> target state: halted
> target halted in ARM state due to breakpoint, current mode: Supervisor
> cpsr: 0x40000013 pc: 0x8057c7e0
> MMU: enabled, D-Cache: enabled, I-Cache: enabled
>
> pc doesn't change anymore.
>
> The board bsp (with the add_imx_fb(...) line) is this one: 
> http://paste.debian.net/hidden/10d828f8/
> And this is based on bsp from Freescale MX25 3DS board: 
> http://paste.debian.net/hidden/50ada4ee/ or 
> arch/arm/mach-imx/mach-mx25_3ds.c in kernel tree
>
> There a two screenshots from ddd-Debugger attached.
> The on is code view, and the other the backtrace.
>
> What could be the problem?
>
> (Display is connected via LVDS).
>
> Thanks
>
> Stefan Koch
>

