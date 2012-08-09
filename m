Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab2HIThL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:37:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51421 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759292Ab2HIThI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:37:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] timekeeping: Fix build when generic clockevents are enabled
Date: Thu, 9 Aug 2012 21:43:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1344513580-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1344513580-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208092143.03871.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 09, 2012, Mark Brown wrote:
> Commit a2c204 (timekeeping: Add suspend and resume of clock event devices)
> added suspend and resume operations for clockevents but did not provide
> stubs for these functions, breaking the build when clockevents are not
> being built. Add the stubs.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I've fixed that already in my tree.

Thanks,
Rafael


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
> 

