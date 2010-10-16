Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0JPMmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 08:42:50 -0400
Received: from mx1.melware.net ([78.47.171.162]:54770 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab0JPMmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 08:42:49 -0400
Date: Sat, 16 Oct 2010 14:42:48 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Tejun Heo <tj@kernel.org>
cc: Karsten Keil <isdn@linux-pingi.de>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2.6.36-rc7] isdn/eicon: don't call flush_scheduled_work()
 from diva_os_remove_soft_isr()
In-Reply-To: <4CB84FAF.5080608@kernel.org>
Message-ID: <alpine.DEB.2.00.1010161441040.27329@justus.melware.de>
References: <4CB84FAF.5080608@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010, Tejun Heo wrote:
> diva doesn't use workqueue and there is no reason to flush the system
> workqueue from diva_os_remove_soft_isr().  Remove it.
>
> This is to prepare for the deprecation and removal of
> flush_scheduled_work().

This is a leftover. Thanks.

Acked-by: Armin Schindler <armin@melware.de>

> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> drivers/isdn/hardware/eicon/divasmain.c |    2 --
> 1 file changed, 2 deletions(-)
>
> Index: work/drivers/isdn/hardware/eicon/divasmain.c
> ===================================================================
> --- work.orig/drivers/isdn/hardware/eicon/divasmain.c
> +++ work/drivers/isdn/hardware/eicon/divasmain.c
> @@ -15,7 +15,6 @@
> #include <asm/uaccess.h>
> #include <asm/io.h>
> #include <linux/ioport.h>
> -#include <linux/workqueue.h>
> #include <linux/pci.h>
> #include <linux/interrupt.h>
> #include <linux/list.h>
> @@ -546,7 +545,6 @@ void diva_os_remove_soft_isr(diva_os_sof
> 		void *mem;
>
> 		tasklet_kill(&pdpc->divas_task);
> -		flush_scheduled_work();
> 		mem = psoft_isr->object;
> 		psoft_isr->object = NULL;
> 		diva_os_free(0, mem);
>
