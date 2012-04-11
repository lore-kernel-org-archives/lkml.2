Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582Ab2DKPHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:07:04 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:23618 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760284Ab2DKPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:07:01 -0400
Message-ID: <4F859DCC.6040307@atmel.com>
Date: Wed, 11 Apr 2012 17:05:48 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Pavel Pisa <ppisa@pikron.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Will Newton <will.newton@imgtec.com>
Subject: Re: [PATCH] mmc: remove linux/blkdev.h include from host drivers
References: <1334084783-3572-1-git-send-email-mad_soft@inbox.ru>
In-Reply-To: <1334084783-3572-1-git-send-email-mad_soft@inbox.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Le 04/10/2012 09:06 PM, Dmitry Artamonow a écrit :
> None of mmc host drivers using linux/blkdev.h header
> really need anything from it. The slight exception is
> atmel-mci, which uses blkdev.h only because it indirectly
> pulls asm/cacheflush.h
>
> So remove any inclusion of blkdev.h - it should also fix
> build errors of dw_mmc and atmel-mci drivers when
> CONFIG_BLOCK is disabled, like following:
> ------------------------------------------------------
> In file included from drivers/mmc/host/dw_mmc.c:14:0:
> include/linux/blkdev.h:1408:42: warning: ‘struct task_struct’ declared inside parameter list [enabled by default]
> include/linux/blkdev.h:1408:42: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> include/linux/blkdev.h:1412:51: warning: ‘struct task_struct’ declared inside parameter list [enabled by default]
> include/linux/blkdev.h:1417:1: error: unknown type name ‘bool’
> include/linux/blkdev.h:1417:48: warning: ‘struct task_struct’ declared inside parameter list [enabled by default]
> include/linux/blkdev.h: In function ‘blk_needs_flush_plug’:
> include/linux/blkdev.h:1419:9: error: ‘false’ undeclared (first use in this function)
> include/linux/blkdev.h:1419:9: note: each undeclared identifier is reported only once for each function it appears in
> make[1]: *** [drivers/mmc/host/dw_mmc.o] Error 1
> make: *** [drivers/mmc/host/dw_mmc.o] Error 2
> ------------------------------------------------------
>
> Cc: Ludovic Desroches<ludovic.desroches@atmel.com>
> Cc: Pavel Pisa<ppisa@pikron.com>
> Cc: Sascha Hauer<s.hauer@pengutronix.de>
> Cc: Will Newton<will.newton@imgtec.com>
> Signed-off-by: Dmitry Artamonow<mad_soft@inbox.ru>
> ---
>
>   drivers/mmc/host/at91_mci.c  |    1 -
>   drivers/mmc/host/atmel-mci.c |    2 +-

Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Thanks for your patch.

Regards

Ludovic
