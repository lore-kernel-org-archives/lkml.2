Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab1JGFIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:08:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46209 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759485Ab1JGFIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:08:44 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-7-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-7-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 13:08:23 +0800
Message-ID: <CAMPhdO8FGTw7NzNNjK819zF3GjrRX0ybPyaSFR4U7oG8cGmDtQ@mail.gmail.com>
Subject: Re: [PATCH 06/26] ARM: pxa: add missing header inclusions
To: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> These resulted in build breakage in some configurations:
>
> arch/arm/mach-pxa/irq.c:132:39: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'icip_handle_irq'
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-pxa/irq.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
> index b09e848..848e96d 100644
> --- a/arch/arm/mach-pxa/irq.c
> +++ b/arch/arm/mach-pxa/irq.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/ftrace.h>

It's actually __irq_entry being defined in <linux/ftrace.h> and in turn
__exception_irq_entry being conditionally defined to that.

I think it's better to fix this in <asm/system.h> instead of in the
cases where this macro is referenced?

Russell?

>  #include <linux/io.h>
>  #include <linux/irq.h>
>
> --
> 1.7.5.4
>
>
