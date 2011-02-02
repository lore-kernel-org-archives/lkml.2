Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1BBVDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:03:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37066 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1BBVDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:03:45 -0500
Date: Wed, 2 Feb 2011 21:03:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russ Gorby <russ.gorby@intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "open list:SPI SUBSYSTEM" <spi-devel-general@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] spi: intel_mid_ssp_spi: new SPI driver for intel
	Medfield platform
Message-ID: <20110202210339.GJ9810@sirena.org.uk>
References: <1296680512-2758-2-git-send-email-russ.gorby@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296680512-2758-2-git-send-email-russ.gorby@intel.com>
X-Cookie: 1 bulls, 3 cows.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 01:01:52PM -0800, Russ Gorby wrote:
> SPI master controller driver for the Intel MID platform Medfield
> This driver uses the Penwell SSP controller and configures it to
> be a SPI device (spibus 3). This bus supports a single device -
> the 3G SPI modem that can operate up to 25Mhz.

The same hardware is also used for audio I believe - how do the two
drivers share the hardware?

> +#define SSCR0_DSS   (0x0000000f)     /* Data Size Select (mask) */
> +#define SSCR0_DataSize(x)  ((x) - 1)	/* Data Size Select [4..16] */
> +#define SSCR0_FRF   (0x00000030)     /* FRame Format (mask) */
> +#define SSCR0_Motorola	      (0x0 << 4)	 /* Motorola's SPI mode */
> +#define SSCR0_ECS   (1 << 6) /* External clock select */
> +#define SSCR0_SSE   (1 << 7) /* Synchronous Serial Port Enable */

There certainly looks to be overlap with the register definitions.
