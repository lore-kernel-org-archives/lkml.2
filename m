Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0FXKgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 06:36:21 -0400
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.206.160]:46865 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754449Ab0FXKgT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 06:36:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 74756.93535.bm@omp124.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=JwYwoFMlFXQ94aPZ5evAT2o2UpARGlUXxuZKRG0AzO7PH4sl/iU8z+W3Rbq5ATJ/tc4wi89N7HI7GGcLYxMJZG+9JGgzSphs42aPEs0JJGQxj9G2NT3UboZ+s/YcOgq6XoHmhzhHq/+t0SxvxIv0XnmahO9ZEPMYO9fazhYNAS8=;
Message-ID: <924139.5848.qm@web180311.mail.gq1.yahoo.com>
X-YMail-OSG: dzWRJIsVM1l373E.I0Gz4kpWpyHGnrkxJXO46uph8dU6q1x
 1uxvuGTbrwW1ckwbLLo1Oj_SCKbaDnAxzS60nb9.VcuO.C5pEP3EdwuR4deI
 rT6PZdpL30c8xL5F7D.GXRLdulz7nqaPF0fYSWp0_hn2ZGvxj0g43CfViNTU
 JgxP_tcG_tuBI9N5bcQ5nkLlvMP7V_qKhHMVCqPH5O_DRUlKkr3.ikdR7dYd
 U79sjgc_Jx_vn3x0XOn6ZjY9.KLBB59TPQ9fbCbFn.AZtUOJAH6B3B7oC7CZ
 ETwEJcwcJRfCdop.HqqBJzmJ3UvGv1vJK.xIIPkNASs4Hns5sJNmiu521Vbc
 QsXMtj31B9cIYGx81FMMH8sYl7aFnVahWNQ--
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Thu, 24 Jun 2010 03:36:18 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: RE: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleepinggpios)
To: Ryan Mallon <ryan@bluewatersys.com>, Jon Povey <Jon.Povey@racelogic.co.uk>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       "gregkh@suse.de" <gregkh@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "ext-jani.1.nikula@nokia.com" <ext-jani.1.nikula@nokia.com>,
       =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Wed, 6/23/10, Jon Povey <Jon.Povey@racelogic.co.uk> wrote:
>
> Date: Wednesday, June 23, 2010, 9:46 PM
> Ryan Mallon wrote:
> 
> > If we strip my patch back to just introducing
> gpio_request_cansleep,
> > which would be used in any driver where all of the
> calls are
> > gpio_(set/get)_cansleep, and make gpio_request only
> allow non-sleeping
> > gpios then incorrect use of gpios would be caught at
> request time and
> > returned to the caller as an error.
> 
> It seems like a good idea to catch these at request time.
> There is support in the API for this already
> (gpio_cansleep), but driver writers are not steered towards
> checking and thinking in these ways by the current API or
> 
> gpio_request_cansleep would be the same as current
> gpio_request

I wonder if, by the time I catch up on this
ever-extending email thread

... someone else will have noted that
because gpio_request() can now poke the GPIO
chip, that call might actually need to sleep.
So there'd be a difference between the two
calls:  one would *NEED* to be called in a
sleepable thread context, vs. that just being
well advised (e.g. as part of board setup in
arch init code after tasking is working)...

So that couldn't work quite that way.



