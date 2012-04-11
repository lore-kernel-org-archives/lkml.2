Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2DKKMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:12:07 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:61539 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2DKKMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:12:05 -0400
MIME-Version: 1.0
In-Reply-To: <1334084783-3572-1-git-send-email-mad_soft@inbox.ru>
References: <1334084783-3572-1-git-send-email-mad_soft@inbox.ru>
Date: Wed, 11 Apr 2012 11:11:57 +0100
Message-ID: <CAFbHwiQrq30HO2X4KG1u5J2+dT2dEcZAd0gXEXm7nc7jjm--wg@mail.gmail.com>
Subject: Re: [PATCH] mmc: remove linux/blkdev.h include from host drivers
From: Will Newton <will.newton@gmail.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Pavel Pisa <ppisa@pikron.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Will Newton <will.newton@imgtec.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 8:06 PM, Dmitry Artamonow <mad_soft@inbox.ru> wrote:
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
> Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
> Cc: Pavel Pisa <ppisa@pikron.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Will Newton <will.newton@imgtec.com>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

For the dw_mmc part:

Acked-by: Will Newton <will.newton@imgtec.com>
