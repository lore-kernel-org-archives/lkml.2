Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab1FVTEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:04:39 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:45024 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758702Ab1FVTEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:04:38 -0400
Message-ID: <4E023C72.3030109@metafoo.de>
Date: Wed, 22 Jun 2011 21:03:14 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register access
 API
References: <20110622184407.GC13847@sirena.org.uk> <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 08:45 PM, Mark Brown wrote:
> [...]
> +
> +static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
> +			    unsigned int val_len)
> +{
> +	u8 *u8 = map->work_buf;
> +	int ret;
> +
> +	map->format.format_reg(map->work_buf, reg);
> +
> +	/*
> +	 * Some buses flag reads by setting the high bits in the
> +	 * register addresss; since it's always the high bits for all
> +	 * current formats we can do this here rather than in
> +	 * formatting.  This may break if we get interesting formats.
> +	 */
> +	if (map->bus->read_flag_bit)
> +		u8[0] |= 1 << map->bus->read_flag_bit;

Should be 1 << (map->bus->read_flag_bit - 1)
