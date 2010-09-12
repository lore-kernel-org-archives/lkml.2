Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0ILR1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 13:27:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0ILR1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 13:27:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] PM_SLEEP_SMP: fix kconfig warning
Date: Sun, 12 Sep 2010 19:26:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
References: <20100911155720.c4fe6b4b.randy.dunlap@oracle.com>
In-Reply-To: <20100911155720.c4fe6b4b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009121926.08633.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 12, 2010, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig unmet dependency warning:
> 
> warning: (PM_SLEEP_SMP && SMP && (ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE) && PM_SLEEP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && HOTPLUG)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  kernel/power/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20100908.orig/kernel/power/Kconfig
> +++ linux-next-20100908/kernel/power/Kconfig
> @@ -83,7 +83,7 @@ config PM_TRACE_RTC
>  
>  config PM_SLEEP_SMP
>  	bool
> -	depends on SMP
> +	depends on SMP && HOTPLUG
>  	depends on ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
>  	depends on PM_SLEEP
>  	select HOTPLUG_CPU

I'm afraid that may cause some people to find that suspend is not compiled in
to their surprise.

Would it be possible to select both HOTPLUG and HOTPLUG_CPU instead (ie. would
that work)?

Rafael
