Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab1F2RF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:05:59 -0400
Received: from lunge.queued.net ([173.255.254.236]:58982 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab1F2RF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:05:56 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 13:05:56 EDT
Date: Wed, 29 Jun 2011 09:56:49 -0700
From: Andres Salomon <dilinger@queued.net>
To: Philip Prindeville <philipp@redfish-solutions.com>
Cc: linux-geode@lists.infradead.org, alex@ozo.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] geode: Reflect mfgpt dependency on mfd.
Message-ID: <20110629095649.06ee4d09@queued.net>
In-Reply-To: <1309320009-26092-1-git-send-email-philipp@redfish-solutions.com>
References: <1309320009-26092-1-git-send-email-philipp@redfish-solutions.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks correct to me.  It should probably be sent to Andrew to be queued
up.

Acked-by: Andres Salomon <dilinger@queued.net>

On Tue, 28 Jun 2011
22:00:09 -0600 Philip Prindeville <philipp@redfish-solutions.com> wrote:

> From: Philip A. Prindeville <philipp@redfish-solutions.com>
> 
> As stated in drivers/mfd/cs5535-mfd.c, the mfd driver exposes the BARs
> which then make the GPIO, MFGPT, ACPI, etc. all visible to the system.
> 
> This dependency needs to be reflected in Kconfig.
> 
> Signed-off-by: Philip A. Prindeville <philipp@redfish-solutions.com>
> Acked-by: Alexandros C. Couloumbis <alex@ozo.com>
> ---
>  drivers/misc/Kconfig |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 4e349cd..3546474 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -245,8 +245,7 @@ config SGI_XP
>  
>  config CS5535_MFGPT
>  	tristate "CS5535/CS5536 Geode Multi-Function General Purpose
> Timer (MFGPT) support"
> -	depends on PCI
> -	depends on X86
> +	depends on PCI && X86 && MFD_CS5535
>  	default n
>  	help
>  	  This driver provides access to MFGPT functionality for
> other
