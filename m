Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2FZJJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:09:24 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:60608 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab2FZJJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:09:23 -0400
Message-ID: <4FE97C3E.40508@mev.co.uk>
Date: Tue, 26 Jun 2012 10:09:18 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 28/33] staging: comedi: cb_das16_cs: cleanup das16cs_ai_rinsn()
References: <201206251717.53025.hartleys@visionengravers.com>
In-Reply-To: <201206251717.53025.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-26 01:17, H Hartley Sweeten wrote:
> @@ -129,7 +124,22 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
>   	outw(devpriv->status1, dev->iobase + 4);
>
>   	devpriv->status2 &= ~0xff00;
> -	devpriv->status2 |= range_bits[range];
> +	switch (range) {
> +	case 0:
> +		devpriv->status2 |= 0x800;
> +		break;
> +	case 1:
> +		devpriv->status2 |= 0x000;
> +		break;
> +	case 2:
> +		devpriv->status2 |= 0x100;
> +		break;
> +	case 3:
> +		devpriv->status2 |= 0x200;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

Is that really an improvement?  The 'range' variable value will be in 
range anyway (the comedi core checks beforehand in 
comedi_check_chanlist()), and looking up the constant to OR with 
devpriv->status2 is probably less object code (and certainly less source 
code).

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


