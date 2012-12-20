Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2LTONl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 09:13:41 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61795 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2LTONe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 09:13:34 -0500
X-Originating-IP: 108.223.40.66
Date: Thu, 20 Dec 2012 06:13:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Juergen Beisert <jbe@pengutronix.de>
Subject: Re: [PATCH v2] linux/kernel.h: Fix DIV_ROUND_CLOSEST with unsigned
 divisors
Message-ID: <20121220141344.GA32230@roeck-us.net>
References: <1355928015-26212-1-git-send-email-linux@roeck-us.net>
 <20121219134721.bbde212f.akpm@linux-foundation.org>
 <20121219224122.GA26863@roeck-us.net>
 <20121220112202.3ead1fe1@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220112202.3ead1fe1@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 11:22:02AM +0100, Jean Delvare wrote:
> Hi Guenter,
> 
> On Wed, 19 Dec 2012 14:41:22 -0800, Guenter Roeck wrote:
> > On Wed, Dec 19, 2012 at 01:47:21PM -0800, Andrew Morton wrote:
> > > The changelog didn't describe the end-user visible effects of the bug.
> > > Please always include this information.  Because...
> >
> > One observed effect is that the s2c_hwmon driver reports a value of 4198403
> > instead of 0 if the ADC reads 0.
> > 
> > Other impact is unpredictable. Problem is seen if the divisor is an unsigned
> > variable or constant and the dividend is less than (divisor/2).
> 
> Really? In my own testing, the problem only shows with dividend == 0, and even
> then, only when dividend is signed and divisor is not.  DIV_ROUND_CLOSEST(5,
> 20U) returns 0 as expected, and so do DIV_ROUND_CLOSEST(0 / 20),
> DIV_ROUND_CLOSEST(0U / 20) and DIV_ROUND_CLOSEST(0U / 20U).
> 
> Are your observations different?
> 

Hmm, you are right - it only happens with 0. I thought I had also seen it with
other values.

> > > The patch is applicable to 3.7.x.  Should we backport it?
> >
> > Yes. DIV_ROUND_CLOSEST is used throughout the kernel, and impact is
> > unpredictable.
> > 
> > 3.6 needs it as well.
> 
Turns out 3.6 is EOL, so we'll only need it in 3.7.

Guenter
