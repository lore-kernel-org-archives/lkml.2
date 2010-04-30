Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab0D3Tlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:41:50 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39123 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab0D3Tle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:41:34 -0400
Message-ID: <4BDA7122.6080509@monstr.eu>
Date: Fri, 30 Apr 2010 07:56:50 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][NOMMU] microblaze: re-enable interrupts before calling
 schedule
References: <1272391223-32012-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1272391223-32012-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> schedule() should not be called with interrupts disabled.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
> --- a/arch/microblaze/kernel/entry-nommu.S	2010-04-27 10:14:33.000000000 -0500
> +++ b/arch/microblaze/kernel/entry-nommu.S	2010-04-27 12:53:04.000000000 -0500
> @@ -476,6 +476,8 @@ ENTRY(ret_from_fork)
>  	nop
>  
>  work_pending:
> +	enable_irq
> +
>  	andi	r11, r19, _TIF_NEED_RESCHED
>  	beqi	r11, 1f
>  	bralid	r15, schedule
> 

Applied

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
