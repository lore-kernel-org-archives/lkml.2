Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab0JHS5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:57:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56324 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754532Ab0JHS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:57:29 -0400
Date: Fri, 8 Oct 2010 11:57:40 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeffrey Carlyle <jeff.carlyle@motorola.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Lun Chang <L.chang@motorola.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: avoid deadlock when disabling regulator
 with supply
Message-ID: <20101008185739.GA6098@opensource.wolfsonmicro.com>
References: <20101008163033.GA5092@opensource.wolfsonmicro.com>
 <1286563435-31239-1-git-send-email-jeff.carlyle@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286563435-31239-1-git-send-email-jeff.carlyle@motorola.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 01:43:54PM -0500, Jeffrey Carlyle wrote:

> I have a regulator A that sets regulator B as its supply. When I call
> set_supply to add B as the supply for A, regulator A gets added to the
> supply_list for regulator B.

Looks good, thanks!

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but some stylistic things below:

> Change-Id: I769669452b9e1b59b252298d589738aabb03529c

Hrm?

>  static int _regulator_get_voltage(struct regulator_dev *rdev);
>  static int _regulator_get_current_limit(struct regulator_dev *rdev);
>  static unsigned int _regulator_get_mode(struct regulator_dev *rdev);
> @@ -1343,12 +1344,14 @@ int regulator_enable(struct regulator *regulator)
>  	mutex_lock(&rdev->mutex);
>  	ret = _regulator_enable(rdev);
>  	mutex_unlock(&rdev->mutex);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(regulator_enable);

Random indentation change here.

> +
> +	if (supply_rdev)
> +		regulator_disable(
> +				get_device_regulator(rdev_get_dev(supply_rdev))
> +				);
> +

Eew, indentation!  In cases like this it's better to just ignore the
excesive line length.
