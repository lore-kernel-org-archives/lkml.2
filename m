Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab2LTAh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:37:27 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49772 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2LTAhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:37:20 -0500
X-Greylist: delayed 21400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 19:37:20 EST
Date: Wed, 19 Dec 2012 16:37:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christophe TORDEUX <christophe@tordeux.net>
Cc: Henrik Rydberg <rydberg@euromail.se>, Tai-hwa Liang <avatar@sentelic.com>,
        Oskari Saarenmaa <os@ohmu.fi>, Paul Fox <pgf@laptop.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 01/01] Input multitouch: fix horizontal
 two-finger-scrolling on Sentelic touchpads
Message-ID: <20121220003705.GA29672@core.coreip.homeip.net>
References: <20121212012135.GA9043@sherka.no-ip.biz>
 <20121219230945.GA25106@sherka.no-ip.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219230945.GA25106@sherka.no-ip.biz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 12:09:45AM +0100, Christophe TORDEUX wrote:
> From: Christophe TORDEUX <christophe@tordeux.net>
> 
> Apply the following change to the Sentelic touchpad driver:
> report only the position of the first finger as absolute non-MT 
> coordinates, instead of reporting both fingers alternatively. Actual MT 
> events are unaffected.
> 
> Signed-off-by: Christophe TORDEUX <christophe@tordeux.net>
> ----
> 
> This is a much simpler version of my patch. Basically, it makes little 
> sense to report both fingers alternatively, as long as it's non-MT 
> events. With this approach, storing coordinates of the previously 
> reported touch is not necessary. This patch is against kernel version 
> 3.7. Works with a touchpad version STL3888_C0, very probably works on 
> all later version, and very probably does not impact any earlier 
> version. This patch has two effects:
> 1) fix horizontal and improve vertical scrolling, though maybe in a
> coincidental way and 2) work towards making the non-MT absolute events
> a purely legacy single finger fallback mode, without breaking anything.

OK, this makes a lot of sense and I will be applying this; thanks!

> 
> diff -uprN -X vanilla/linux-3.7-rc8/Documentation/dontdiff vanilla/linux-3.7/drivers/input/mouse/sentelic.c linux-3.7/drivers/input/mouse/sentelic.c
> --- vanilla/linux-3.7/drivers/input/mouse/sentelic.c	2012-12-15 13:51:58.768136524 +0100
> +++ linux-3.7/drivers/input/mouse/sentelic.c	2012-12-19 23:26:49.289517251 +0100
> @@ -791,7 +791,7 @@ static psmouse_ret_t fsp_process_byte(st
>  			fsp_set_slot(dev, 0, fgrs > 0, abs_x, abs_y);
>  			fsp_set_slot(dev, 1, false, 0, 0);
>  		}
> -		if (fgrs > 0) {
> +		if (fgrs ==1 || (fgrs == 2 && !(packet[0] & FSP_PB0_MFMC_FGR2))) {
>  			input_report_abs(dev, ABS_X, abs_x);
>  			input_report_abs(dev, ABS_Y, abs_y);
>  		}



-- 
Dmitry
