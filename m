Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2HGQ2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:28:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49076 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2HGQ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:28:46 -0400
Date: Tue, 7 Aug 2012 17:28:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Ashish Jangam'" <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH 1/3] backlight: da9052: Use usleep_range() instead of
 msleep() for small sleeps
Message-ID: <20120807162821.GA14711@sirena.org.uk>
References: <002c01cd738e$14a880b0$3df98210$%han@samsung.com>
 <CAK9yfHyw=6-e28mHrhyhTuC2uykeqQzpsGRfXcWmcaON=NvcPw@mail.gmail.com>
 <002f01cd7390$4873b5c0$d95b2140$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002f01cd7390$4873b5c0$d95b2140$%han@samsung.com>
X-Cookie: Now, let's SEND OUT for QUICHE!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 01:59:38PM +0900, Jingoo Han wrote:
> On Monday, August 06, 2012 1:48 PM Sachin Kamat wrote:

> > > +       usleep_range(10000, 11000);

> > Can't we just use usleep(10000) instead?

> usleep() is not available.
> For more details, refer to Documentation/timers/timers-howto.txt.

Given how common this pattern is is it not more sensible to just
provide usleep() even if just as an inline that's something like

   void usleep(unsigned long t)
   {
   	usleep_range(t, t + (t / 10));
   }

since the usleep_range() isn't ideal for clarity (and usually the upper
bound isn't a particular concern for the driver, it just wants the usual
"delay for at least x" semantics).
