Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0EKLDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 07:03:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab0EKLDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 07:03:00 -0400
Date: Tue, 11 May 2010 13:58:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: return correct value when writing to the "reset"
	attribute
Message-ID: <20100511105859.GA2295@redhat.com>
References: <20100511094453.12485.43792.stgit@leela.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511094453.12485.43792.stgit@leela.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 11:44:54AM +0200, Michal Schmidt wrote:
> A successful write() to the "reset" sysfs attribute should return the
> number of bytes written, not 0. Otherwise userspace (bash) retries the
> write over and over again.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> 
>  drivers/pci/pci-sysfs.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index fad9398..ba88a2f 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -960,7 +960,12 @@ static ssize_t reset_store(struct device *dev,
>  
>  	if (val != 1)
>  		return -EINVAL;
> -	return pci_reset_function(pdev);
> +
> +	result = pci_reset_function(pdev);
> +	if (result < 0)
> +		return result;
> +
> +	return count;
>  }
>  
>  static struct device_attribute reset_attr = __ATTR(reset, 0200, NULL, reset_store);
