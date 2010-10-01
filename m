Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0JAXBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 19:01:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59692 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752301Ab0JAXBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 19:01:20 -0400
Date: Fri, 1 Oct 2010 16:01:33 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, Alek Du <alek.du@intel.com>,
        Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@mocean-labs.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, andrew.chih.howe.khor@intel.com,
        kok.howg.ewe@intel.com, joel.clark@intel.com, yong.y.wang@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, margie.foster@intel.com
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_GPIO driver to
 2.6.35
Message-ID: <20101001230133.GG21157@opensource.wolfsonmicro.com>
References: <4CA29466.602@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA29466.602@dsn.okisemi.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:20:38AM +0900, Masayuki Ohtak wrote:

> +static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
> +				     int val)
> +{
> +	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
> +	u32 pm;
> +
> +	mutex_lock(&chip->lock);
> +	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS;
> +	pm |= (1 << nr);
> +	iowrite32(pm, &chip->reg->pm);
> +	mutex_unlock(&chip->lock);
> +
> +	return 0;
> +}

This doesn't do anything with val - it should be doing the equivalent of
a gpio_set() to set the initial value of the GPIO when switching it to
output mode.

Otherwise this looks good.
