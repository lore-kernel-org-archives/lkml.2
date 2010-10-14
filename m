Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab0JNTuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:50:20 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:56279 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab0JNTuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:50:16 -0400
Date: Thu, 14 Oct 2010 21:50:14 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH -next v2] mmc: fix cb710 kconfig dependency warning
Message-ID: <20101014195014.GA28386@rere.qmqm.pl>
References: <20101013181519.6ff00e10.randy.dunlap@oracle.com> <20101014090442.GA14454@rere.qmqm.pl> <4CB74C5F.4000905@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CB74C5F.4000905@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 11:30:55AM -0700, Randy Dunlap wrote:
> Fix kconfig dependency warning to satisfy dependencies:
> warning: (MMC_CB710 && MMC && PCI) selects CB710_CORE which has unmet direct dependencies (MISC_DEVICES && PCI)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/mmc/host/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20101013.orig/drivers/mmc/host/Kconfig
> +++ linux-next-20101013/drivers/mmc/host/Kconfig
> @@ -395,6 +395,7 @@ config MMC_TMIO
>  config MMC_CB710
>  	tristate "ENE CB710 MMC/SD Interface support"
>  	depends on PCI
> +	select MISC_DEVICES
>  	select CB710_CORE
>  	help
>  	  This option enables support for MMC/SD part of ENE CB710/720 Flash

Acked-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

It would be better, thoughm if MISC_DEVICES was some kind of ghost config
entry that needs no selecting or depending on as it is used only for users
convenience - config tree decoration maybe.

Best Regards,
Micha³ Miros³aw
