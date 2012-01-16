Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2APQMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:12:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59718 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab2APQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:12:52 -0500
Date: Mon, 16 Jan 2012 09:12:48 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio-ml-ioh: cleanup __iomem annotation usage
Message-ID: <20120116161248.GB4223@ponder.secretlab.ca>
References: <4F12A30E.7080808@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F12A30E.7080808@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 10:57:34AM +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The __iomem annotation is to be used together with pointers used
> in iowrite32() but not for pointers returned by kzalloc().
> For more details see [1] and [2].
> 
> This patch will remove the following sparse warning (i.e. when
> copiling with "make C=1"):
>  * warning: incorrect type in assignment (different address spaces)
> 
> References:
> [1] A new I/O memory access mechanism (Sep 15, 2004)
>     http://lwn.net/Articles/102232/
> 
> [2] Being more anal about iospace accesses (Sep 15, 2004)
>     http://lwn.net/Articles/102240/
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Applied all 4.  Thanks

g.

> ---
>  drivers/gpio/gpio-ml-ioh.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
> index 461958f..25da40a 100644
> --- a/drivers/gpio/gpio-ml-ioh.c
> +++ b/drivers/gpio/gpio-ml-ioh.c
> @@ -248,7 +248,7 @@ static void ioh_gpio_setup(struct ioh_gpio *chip, int num_port)
>  static int ioh_irq_type(struct irq_data *d, unsigned int type)
>  {
>  	u32 im;
> -	u32 *im_reg;
> +	void __iomem *im_reg;
>  	u32 ien;
>  	u32 im_pos;
>  	int ch;
> @@ -412,7 +412,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
>  	int i, j;
>  	struct ioh_gpio *chip;
>  	void __iomem *base;
> -	void __iomem *chip_save;
> +	void *chip_save;
>  	int irq_base;
> 
>  	ret = pci_enable_device(pdev);
> @@ -521,7 +521,7 @@ static void __devexit ioh_gpio_remove(struct pci_dev *pdev)
>  	int err;
>  	int i;
>  	struct ioh_gpio *chip = pci_get_drvdata(pdev);
> -	void __iomem *chip_save;
> +	void *chip_save;
> 
>  	chip_save = chip;
> 
> -- 
> 1.7.2.5
> 
