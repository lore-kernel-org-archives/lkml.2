Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1KTW2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 17:28:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48367 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab1KTW2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 17:28:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Fries <david@fries.net>
Subject: Re: [PATH] pci_has_legacy_pm_support add driver and device to WARN
Date: Sun, 20 Nov 2011 23:31:00 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org
References: <20111120212945.GA1781@spacedout.fries.net>
In-Reply-To: <20111120212945.GA1781@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111202331.00548.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 20, 2011, David Fries wrote:
> From: David Fries <David@Fries.net>
> 
> Include the driver name and device in warning when a pci driver
> supports both legacy pm and new framework as just the stack trace
> gives no way to identify the driver.
> 
> Signed-off-by: David Fries <David@Fries.net>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/pci-driver.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 12d1e81..3623d65 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -604,7 +604,8 @@ static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
>  	 * supported as well.  Drivers are supposed to support either the
>  	 * former, or the latter, but not both at the same time.
>  	 */
> -	WARN_ON(ret && drv->driver.pm);
> +	WARN(ret && drv->driver.pm, "driver %s device %04x:%04x\n",
> +		drv->name, pci_dev->vendor, pci_dev->device);
>  
>  	return ret;
>  }
> 

