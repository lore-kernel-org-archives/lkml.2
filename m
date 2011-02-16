Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1BPRjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:39:19 -0500
Received: from juliet.he.net ([184.105.210.2]:44884 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753591Ab1BPRjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:39:14 -0500
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Feb 2011 12:39:14 EST
Date: Wed, 16 Feb 2011 09:29:02 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] ARM: reenable DEBUG_SECTION_MISMATCH
Message-Id: <20110216092902.3e6e97b2.rdunlap@xenotime.net>
In-Reply-To: <1297876993-4146-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297876993-4146-1-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 18:23:13 +0100 Uwe Kleine-König wrote:

> For 2.6.38-rc4-git9 only 29 out of 133 defconfigs still produce section
> mismatches.  These defconfigs produce 55 mismatches (weighted sum, so
> maybe less uniq mismatches).
> 
> This is in my opinion enough to start scaring people about the remaining
> problems.

Yes, we have way too many of these and need more eyes on them.


> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

> ---
>  lib/Kconfig.debug |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 3967c23..1130dd4 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -102,7 +102,7 @@ config HEADERS_CHECK
>  
>  config DEBUG_SECTION_MISMATCH
>  	bool "Enable full Section mismatch analysis"
> -	depends on UNDEFINED || (BLACKFIN)
> +	depends on ARM || BLACKFIN

I would even like something like this:

	depends on ARM || BLACKFIN || KERNEL_DEVELOPER

or even
	select DEBUG_SECTION_MISMATCH if KERNEL_DEVELOPER

to make these warnings appear... but even with today's other warnings, lots
of them are ignored.


>  	default y
>  	# This option is on purpose disabled for now.
>  	# It will be enabled when we are down to a reasonable number
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
