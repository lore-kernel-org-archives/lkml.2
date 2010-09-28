Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0I1R5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:57:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43515 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753452Ab0I1R5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:57:52 -0400
Date: Tue, 28 Sep 2010 10:58:09 -0700
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
Subject: Re: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_GPIO driver to
 2.6.35
Message-ID: <20100928175808.GG10739@opensource.wolfsonmicro.com>
References: <4CA1B775.9020809@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA1B775.9020809@dsn.okisemi.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 06:37:57PM +0900, Masayuki Ohtak wrote:

> +	gpio->base = (u32)chip->pch_gpio_base_address;

> +	chip->reg = chip->pch_gpio_base_address;

The GPIO base passed to gpiolib should be the base GPIO number for the
device, not the address of the control registers.  Normally this would
be passed in via platform data or set to -1 to allow the core to assign
a slot.
