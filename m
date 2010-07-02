Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab0GBUxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 16:53:46 -0400
Received: from www.tglx.de ([62.245.132.106]:41684 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab0GBUxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 16:53:45 -0400
Date: Fri, 2 Jul 2010 22:53:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       jacob.jun.pan@intel.com, dtor@mail.ru, randy.dunlap@oracle.com
Subject: Re: [PATCH 5/5] input: i8042 - add runtime check in x86's
 i8042_platform_init
In-Reply-To: <1278059716-7147-6-git-send-email-feng.tang@intel.com>
Message-ID: <alpine.LFD.2.00.1007022252480.2525@localhost.localdomain>
References: <1278059716-7147-1-git-send-email-feng.tang@intel.com> <1278059716-7147-6-git-send-email-feng.tang@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010, feng.tang@intel.com wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> Then it will first check x86_platforms's i8042 detection result,
> then go on with normal probe.
> 
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  drivers/input/serio/i8042-x86ia64io.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index 6168469..2e14fc5 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -840,6 +840,10 @@ static int __init i8042_platform_init(void)
>  {
>  	int retval;
>  
> +	/* Just return if pre-detection shows no i8042 controller exist */
> +	if (!x86_platform.i8042_detect())
> +		return -ENODEV;

That's going to break IA64 :(

Thanks,

	tglx
