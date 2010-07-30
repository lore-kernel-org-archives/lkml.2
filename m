Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab0G3PTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:19:33 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12578 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0G3PTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:19:31 -0400
Message-ID: <4C52ED82.6040703@caviumnetworks.com>
Date: Fri, 30 Jul 2010 08:19:30 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] staging: octeon: check request_irq() return value
References: <1280488062-20737-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1280488062-20737-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2010 15:19:31.0283 (UTC) FILETIME=[9BD33230:01CB2FFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2010 04:07 AM, Kulikov Vasiliy wrote:
> request_irq() may fail, if so propagate error code.
>
> Signed-off-by: Kulikov Vasiliy<segooon@gmail.com>

You can add:

Acked-by: David Daney <ddaney@caviumnetworks.com>


> ---
>   drivers/staging/octeon/ethernet-spi.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/octeon/ethernet-spi.c b/drivers/staging/octeon/ethernet-spi.c
> index b58b897..9708254 100644
> --- a/drivers/staging/octeon/ethernet-spi.c
> +++ b/drivers/staging/octeon/ethernet-spi.c
> @@ -294,6 +294,8 @@ int cvm_oct_spi_init(struct net_device *dev)
>   	if (number_spi_ports == 0) {
>   		r = request_irq(OCTEON_IRQ_RML, cvm_oct_spi_rml_interrupt,
>   				IRQF_SHARED, "SPI",&number_spi_ports);
> +		if (r)
> +			return r;
>   	}
>   	number_spi_ports++;
>

