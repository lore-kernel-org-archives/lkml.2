Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab0EDAOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 20:14:42 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:15547 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab0EDAOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 20:14:40 -0400
Message-ID: <4BDF66E2.6010308@chelsio.com>
Date: Mon, 03 May 2010 17:14:26 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/10] drivers: net: use new hex_to_bin() method
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com> <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com> <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com> <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com> <c1ca828fb308042aa32428b345abcb43ccb02c39.1272617852.git.ext-andriy.shevchenko@nokia.com> <2eb558b7b0b20dfea0b61223db6146cb8fdbe52d.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <2eb558b7b0b20dfea0b61223db6146cb8fdbe52d.1272617852.git.ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 May 2010 00:17:35.0578 (UTC) FILETIME=[3269ABA0:01CAEB1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 02:34 AM, Andy Shevchenko wrote:
> Get rid of own implementation of hex_to_bin(). It requires to have hex_to_bin()
> introduced by starter patch in series.
>
> Signed-off-by: Andy Shevchenko<ext-andriy.shevchenko@nokia.com>
> Cc: Divy Le Ray<divy@chelsio.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>
>    

Acked-by: Divy Le Ray <divy@chelsio.com>

> ---
>   drivers/net/cxgb3/t3_hw.c |   16 ++++------------
>   1 files changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
> index 95a8ba0..427c451 100644
> --- a/drivers/net/cxgb3/t3_hw.c
> +++ b/drivers/net/cxgb3/t3_hw.c
> @@ -679,14 +679,6 @@ int t3_seeprom_wp(struct adapter *adapter, int enable)
>   	return t3_seeprom_write(adapter, EEPROM_STAT_ADDR, enable ? 0xc : 0);
>   }
>
> -/*
> - * Convert a character holding a hex digit to a number.
> - */
> -static unsigned int hex2int(unsigned char c)
> -{
> -	return isdigit(c) ? c - '0' : toupper(c) - 'A' + 10;
> -}
> -
>   /**
>    *	get_vpd_params - read VPD parameters from VPD EEPROM
>    *	@adapter: adapter to read
> @@ -727,15 +719,15 @@ static int get_vpd_params(struct adapter *adapter, struct vpd_params *p)
>   		p->port_type[0] = uses_xaui(adapter) ? 1 : 2;
>   		p->port_type[1] = uses_xaui(adapter) ? 6 : 2;
>   	} else {
> -		p->port_type[0] = hex2int(vpd.port0_data[0]);
> -		p->port_type[1] = hex2int(vpd.port1_data[0]);
> +		p->port_type[0] = hex_to_bin(vpd.port0_data[0]);
> +		p->port_type[1] = hex_to_bin(vpd.port1_data[0]);
>   		p->xauicfg[0] = simple_strtoul(vpd.xaui0cfg_data, NULL, 16);
>   		p->xauicfg[1] = simple_strtoul(vpd.xaui1cfg_data, NULL, 16);
>   	}
>
>   	for (i = 0; i<  6; i++)
> -		p->eth_base[i] = hex2int(vpd.na_data[2 * i]) * 16 +
> -				 hex2int(vpd.na_data[2 * i + 1]);
> +		p->eth_base[i] = hex_to_bin(vpd.na_data[2 * i]) * 16 +
> +				 hex_to_bin(vpd.na_data[2 * i + 1]);
>   	return 0;
>   }
>
>    

