Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1GEGPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:15:52 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34702 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1GEGPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:15:51 -0400
Message-ID: <4E12AC10.9020206@gmail.com>
Date: Tue, 05 Jul 2011 16:15:44 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [RFC/RFT 1/2] gpio/basic_mmio: add support for enable register
References: <cover.1309840042.git.nsekhar@ti.com> <83915224c24e43224272b1bf570cddb9545279a6.1309840042.git.nsekhar@ti.com>
In-Reply-To: <83915224c24e43224272b1bf570cddb9545279a6.1309840042.git.nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/11 15:10, Sekhar Nori wrote:
> Some GPIO controllers have an enable register
> which needs to be written to before a GPIO
> can be used.
>
> Add support for enabling the GPIO. At this
> time inverted logic for enabling the GPIO
> is not supported. This can be done by adding
> a disable register as and when a controller
> with this comes along.
>
> Signed-off-by: Sekhar Nori<nsekhar@ti.com>
> ---
>
<snip>

> static int bgpio_setup_io(struct bgpio_chip *bgc,
>   			  void __iomem *dat,
> @@ -369,6 +401,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
>   			 void __iomem *clr,
>   			 void __iomem *dirout,
>   			 void __iomem *dirin,
> +			 void __iomem *en,
>   			 bool big_endian)

The arguments to this function are getting a bit unwieldy :-). Maybe we 
need to introduce something like:

struct bgpio_chip_info {
     struct device *dev;
     unsigned long sz;
     void __iomem *dat;
     void __iomem *set;
     void __iomem *clr;
     void __iomem *dirout;
     void __iomem *dirin;
     void __iomem *en;
     bool big_endian;
};

and pass that to bgpio_init instead. It would have the added benefits of 
making the drivers more readable and that bgpio_chip_info structs in the 
drivers can probably be marked __initdata also.

Since you are already having to touch all of the call sites for 
bgpio_init this could be done as a separate patch along with this series.

~Ryan

