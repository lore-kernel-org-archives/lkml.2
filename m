Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab1F0P50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:57:26 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56608 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752482Ab1F0P5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:57:24 -0400
Date: Mon, 27 Jun 2011 10:57:21 -0500 (CDT)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 11/12] MISC: IOC4: Fix section mismatch / race
 condition.
In-Reply-To: <2ecba7369d1ac0d7b1ab08ccce65f240719f99c8.1309182743.git.ralf@linux-mips.org>
Message-ID: <alpine.DEB.2.00.1106271056200.28116@pkunk.americas.sgi.com>
References: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org> <2ecba7369d1ac0d7b1ab08ccce65f240719f99c8.1309182743.git.ralf@linux-mips.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: "Silicon Graphics, Inc."
Importance: normal
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, Ralf Baechle wrote:

> WARNING: drivers/misc/ioc4.o(.data+0x144): Section mismatch in reference from the variable ioc4_load_modules_work to the function .devinit.text:ioc4_load_modules()
> The variable ioc4_load_modules_work references
> the function __devinit ioc4_load_modules()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> This one is potencially fatal; by the time ioc4_load_modules is invoked
> it may already have been freed.  For that reason ioc4_load_modules_work
> can't be turned to __devinitdata but also because it's referenced in
> ioc4_exit.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> To: Brent Casavant <bcasavan@sgi.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mips@linux-mips.org
> ---
>  drivers/misc/ioc4.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
> index 668d41e..df03dd3 100644
> --- a/drivers/misc/ioc4.c
> +++ b/drivers/misc/ioc4.c
> @@ -270,7 +270,7 @@ ioc4_variant(struct ioc4_driver_data *idd)
>  	return IOC4_VARIANT_PCI_RT;
>  }
>  
> -static void __devinit
> +static void
>  ioc4_load_modules(struct work_struct *work)
>  {
>  	request_module("sgiioc4");
> -- 
> 1.7.4.4
> 

Acked-by: Brent Casavant <bcasavan@sgi.com>

-- 
Brent Casavant
Silicon Graphics International
