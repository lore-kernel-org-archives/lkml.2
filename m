Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638Ab0FQS2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:28:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46198 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab0FQS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AyumKoYbasCxNCzWjFmqn8BTbgotPHD2NfY5gxrxmbu0OynJQf5CPA3NAFw5Pfw7Q6
         R8TgfzzxPPUTxqBkeP3G1sYkCt5eBIzoMMmifCnFt9cjSr555O2HZ2DlU3qIaLyfdWnZ
         3EBTENzedOBjCKxUxmx8RnHc/mvDnxOZWa/DU=
Date: Thu, 17 Jun 2010 21:59:47 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel MID platform battery driver. (right patch this
 time)
Message-ID: <20100617175947.GA1655@oksana.dev.rtsoft.ru>
References: <20100617171219.9624.53710.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100617171219.9624.53710.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 06:12:36PM +0100, Alan Cox wrote:
> Oops sorry - try the right version this time.
> 
> From: Nithish Mahalingam <nithish.mahalingam@intel.com>
> 
> The PMIC Battery driver provides battery charging and battery gauge
> functionality on Intel MID platforms. This provides the basic functions. There
> are some USB drivers to merge before the selection of charging between the
> different USB power levels can be enabled.
> 
> Moved to a platform device by Alek Du.
> 
> Signed-off-by: Nithish Mahalingam <nithish.mahalingam@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Applied to battery-2.6.git, thanks.

However, note that there's another issue that should be fixed
both in this driver and in the platform (or SPI device driver)
code.

[...]
> +static __devinit int probe(int irq, struct device *dev)

Notice 'int irq' here.

[...]
> +static int __devinit platform_pmic_battery_probe(struct platform_device *pdev)
> +{
> +	return probe(pdev->id, &pdev->dev);

So the irq number is derived from the platform device ID.
Which is very bizarre, and not how things supposed to work.
I guess there should be an IRQ resource for the device
instead.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
