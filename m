Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2BLL5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 06:57:38 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:58868 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab2BLL5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 06:57:37 -0500
Message-ID: <4F37A925.90507@metafoo.de>
Date: Sun, 12 Feb 2012 12:57:25 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V4 2/2] regmap: add regmap_bulk_write() for register write
References: <1329036556-15408-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1329036556-15408-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 09:49 AM, Laxman Dewangan wrote:
> [...]
> +	} else {
> +		for (i = 0; i < val_count; i++) {
> +			memcpy(&ival, val + (i * val_bytes), val_bytes);

This will have endianess issues. You'll need something like regcache_get_val.

> +			ret = _regmap_write(map, reg + i, ival);
> +			if (ret) {
> +				dev_err(map->dev,
> +				    "Error in register %u write, ret %d\n",
> +						reg + i, ret);
> +				break;
> +			}
> +		}
> +	}
> [...]
