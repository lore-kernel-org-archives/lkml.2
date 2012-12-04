Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2LDO0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:26:41 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51981 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2LDO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:26:40 -0500
Date: Tue, 4 Dec 2012 14:31:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, alan@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 07/15] mei: use wrietl/readl instead of io
 wrappers
Message-ID: <20121204143151.1cce530a@pyramind.ukuu.org.uk>
In-Reply-To: <1354629884-3202-7-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
	<1354629884-3202-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2012 16:04:36 +0200
Tomas Winkler <tomas.winkler@intel.com> wrote:

> on intel registers are alwasy memory mapped so drop
> the overhead of iowrite32 and ioread32
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/mei_dev.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
> index 92a5d9a..37eb041 100644
> --- a/drivers/misc/mei/mei_dev.h
> +++ b/drivers/misc/mei/mei_dev.h
> @@ -438,7 +438,7 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots);
>  static inline u32 mei_reg_read(const struct mei_device *dev,
>  			       unsigned long offset)
>  {
> -	return ioread32(dev->mem_addr + offset);
> +	return readl(dev->mem_addr + offset);
>  }
>  
>  /**
> @@ -451,7 +451,7 @@ static inline u32 mei_reg_read(const struct mei_device *dev,
>  static inline void mei_reg_write(const struct mei_device *dev,
>  				 unsigned long offset, u32 value)
>  {
> -	iowrite32(value, dev->mem_addr + offset);
> +	writel(value, dev->mem_addr + offset);

ioremap should match readl/writel
iomap iowrite32/ioread32 

so you need to tweak the map/unmap if you do this.

As to overhead. I'd love to see a measurement that can detect the
difference. Do you have a benchmark that shows it ?
