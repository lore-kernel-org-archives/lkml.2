Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2F1TG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:06:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29995 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2F1TGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:06:24 -0400
Date: Thu, 28 Jun 2012 22:06:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 04/19] staging: comedi: adl_pci6208: document the
 register map of the device
Message-ID: <20120628190602.GM5333@mwanda>
References: <201206271456.44218.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206271456.44218.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 02:56:43PM -0700, H Hartley Sweeten wrote:
> Add defines for the register map of the device. These will be
> used to clarify the code.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/comedi/drivers/adl_pci6208.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
> index f949d20..b6a8439 100644
> --- a/drivers/staging/comedi/drivers/adl_pci6208.c
> +++ b/drivers/staging/comedi/drivers/adl_pci6208.c
> @@ -53,6 +53,18 @@ References:
>   */
>  #include "../comedidev.h"
>  
> +/*
> + * PCI-6208/6216-GL register map
> + */
> +#define PCI6208_AO_CONTROL(x)		(0x00 + (2 * (x)))
> +#define PCI6208_AO_STATUS		0x00
> +#define PCI6208_AO_STATUS_DATA_SEND	(1 << 0)
> +#define PCI6208_DIO			0x40
> +#define PCI6208_DIO_DO_MASK		(0x0f)
> +#define PCI6208_DIO_DO_SHIFT		(0)
> +#define PCI6208_DIO_DI_MASK		(0xf0)
> +#define PCI6208_DIO_DI_SHIFT		(4)

This series is nice and I'm not nacking anything, but really is it
that useful to say:
	status = inw(dev->iobase + PCI6208_AO_STATUS);
instead of just?:
	status = inw(dev->iobase);

I'm not sure what the 0x00 in PCI6208_AO_CONTROL represents.  Some
of these are not used like PCI6208_DIO_DI_SHIFT.

Does checkpatch.pl complain if you leave off these parenthesis?  If
so I will complain again to the checkpatch.pl people.  Extra
parenthesis are silly and there not used consistently.  Only
PCI6208_AO_CONTROL() and PCI6208_AO_STATUS_DATA_SEND() need
paranthesis.

Again, I'm fine with this patch and the whole series.  These are
just comments.

regards,
dan carpenter

