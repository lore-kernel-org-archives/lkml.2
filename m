Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2LTKWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:22:17 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:29542 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2LTKWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:22:11 -0500
Date: Thu, 20 Dec 2012 11:22:02 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Juergen Beisert <jbe@pengutronix.de>
Subject: Re: [PATCH v2] linux/kernel.h: Fix DIV_ROUND_CLOSEST with unsigned
  divisors
Message-ID: <20121220112202.3ead1fe1@endymion.delvare>
In-Reply-To: <20121219224122.GA26863@roeck-us.net>
References: <1355928015-26212-1-git-send-email-linux@roeck-us.net>
	<20121219134721.bbde212f.akpm@linux-foundation.org>
	<20121219224122.GA26863@roeck-us.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Wed, 19 Dec 2012 14:41:22 -0800, Guenter Roeck wrote:
> On Wed, Dec 19, 2012 at 01:47:21PM -0800, Andrew Morton wrote:
> > The changelog didn't describe the end-user visible effects of the bug. 
> > Please always include this information.  Because...
>
> One observed effect is that the s2c_hwmon driver reports a value of 4198403
> instead of 0 if the ADC reads 0.
> 
> Other impact is unpredictable. Problem is seen if the divisor is an unsigned
> variable or constant and the dividend is less than (divisor/2).

Really? In my own testing, the problem only shows with dividend == 0,
and even then, only when dividend is signed and divisor is not.
DIV_ROUND_CLOSEST(5, 20U) returns 0 as expected, and so do
DIV_ROUND_CLOSEST(0 / 20), DIV_ROUND_CLOSEST(0U / 20) and
DIV_ROUND_CLOSEST(0U / 20U).

Are your observations different?

> > The patch is applicable to 3.7.x.  Should we backport it?
>
> Yes. DIV_ROUND_CLOSEST is used throughout the kernel, and impact is
> unpredictable.
> 
> 3.6 needs it as well.

-- 
Jean Delvare
