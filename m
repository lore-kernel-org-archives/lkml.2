Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab2GSJWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:22:49 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44182 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab2GSJWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:22:47 -0400
Message-ID: <5007D1E0.4050503@mev.co.uk>
Date: Thu, 19 Jul 2012 10:22:40 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/90] staging: comedi: comedidev.h: introduce comedi_to_pci_dev()
 helper
References: <201207181824.15722.hartleys@visionengravers.com>
In-Reply-To: <201207181824.15722.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 02:24, H Hartley Sweeten wrote:
> Introduce a wrapper for to_pci_dev() to allow the comedi pci drivers
> to store the pci_dev pointer in the comedi_device hw_dev variable and
> retrieve it easily.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/staging/comedi/comedidev.h | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index de8c99c..620222d 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -446,6 +446,11 @@ static inline void comedi_set_hw_dev(struct comedi_device *dev,
>   	}
>   }
>
> +static inline struct pci_dev *comedi_to_pci_dev(struct comedi_device *dev)
> +{
> +	return to_pci_dev(dev->hw_dev);
> +}
> +

That needs to be something like:

	return dev->hw_dev ? to_pci_dev(dev->hw_dev) : NULL;

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


