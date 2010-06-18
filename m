Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0FRF11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 01:27:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47754 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0FRF1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 01:27:12 -0400
Date: Fri, 18 Jun 2010 07:27:09 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       ext-jani.1.nikula@nokia.com
Subject: Re: gpiolib and sleeping gpios
Message-ID: <20100618052709.GA6392@pengutronix.de>
References: <4C1A980F.8080908@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C1A980F.8080908@bluewatersys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On Fri, Jun 18, 2010 at 09:47:59AM +1200, Ryan Mallon wrote:
> Then all drivers can just call gpio_(set/get)_value and any attempts to
> use sleeping gpios from an non-sleeping context will be caught by the
> might_sleep_if check. Is there something I am missing about this?
The downside is that you change the semantic of gpio_get_value (and
gpio_set_value I assume?).  But as calling gpio_get_value with a gpio
that gpio_cansleep() is an error anyhow, so I think that's OK.  The big
pro is that the API is simplified.
 
> I can prepare a patch which combines the non-sleeping and sleeping
> variants, but I wanted to check that I'm not missing something
> fundamental first.
I will happily look at such a patch and give my comments.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
