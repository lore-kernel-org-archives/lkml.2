Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2HMPHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:07:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:53345 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2HMPHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:07:09 -0400
Date: Mon, 13 Aug 2012 17:07:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timekeeping: Fix build when generic clockevents are
 enabled
In-Reply-To: <1344513580-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Message-ID: <alpine.LFD.2.02.1208131706440.32033@ionos>
References: <1344513580-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012, Mark Brown wrote:

> Commit a2c204 (timekeeping: Add suspend and resume of clock event devices)

Against which tree is that?

> added suspend and resume operations for clockevents but did not provide
> stubs for these functions, breaking the build when clockevents are not
> being built. Add the stubs.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/clockchips.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index ca060db..4f9c280 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -170,6 +170,8 @@ extern void clockevents_notify(unsigned long reason, void *arg);
>  #else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
>  
>  #define clockevents_notify(reason, arg) do { } while (0)
> +#define clockevents_suspend() do { } while (0)
> +#define clockevents_resume() do { } while (0)
>  
>  #endif
>  
> -- 
> 1.7.10.4
> 
> 
