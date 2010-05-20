Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0ETWuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:50:44 -0400
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:33908 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753002Ab0ETWum convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:50:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 790459.42111.bm@omp204.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LDS2wP720waZLNZh3N0jORwj+30ZLB+hg97X5RnwT96L46BzdTZbIMgl+RKdJ/Cx5H1BLamqmGAWUn6xnwwnfFWwRxdyazHXo0mHrqUw3suCcb/n5Os2+cgi3MNcEaVXzzY7zDnggYLeWw/bx9ZfaAGw53cgjQ/xSFRVvTtRuKY=;
Message-ID: <598314.1671.qm@web180305.mail.gq1.yahoo.com>
X-YMail-OSG: FeZ8zSIVM1nZWwfuF8W.mEZcCB1O_gOqeCnUBRmMHG1D7Tu
 WI64zBDb_._JMZP6FdWtv.qoHhWj.yIEk1lNvzwjSVBb21JUwK0mB9v7BiHQ
 pv7eWC788nf6AK1oRu4GHmr9Z9u0QhLPBVKBJesfr1CxdTbfWszXfC6Gkoao
 5Kb88C.etiggB0K8qvolQlFd5cZfNtGkXU4RDA3RA55u7Jzb1zVq.lsT6Ax_
 Ac7HsLx8z0yycVHrAsahQ7cz1cYy1hmaUfKd8WXeV0u0Dttrt8quJvyUzsyy
 ig6XBiSXUErYYhWf42dCtyUiSwRboBMAuUXyd7EWIdl.7HXasBDs5Vw--
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Thu, 20 May 2010 15:50:41 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
To: felipe.balbi@nokia.com, Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100520194509.GB10739@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This would be generally useful for embedded systems,
> especially where the interrupt concerned is a wake source.
>  It allows drivers to avoid
> spurious interrupts from noisy sources so if the hardware
> supports it
> the driver can avoid having to explicitly wait for the
> signal to become
> stable and software has to cope with fewer events.

True.

Not all GPIOs have hardware debounce though, so offering this
capability sort of begs the question of where/how to provide a
software debounce mechanism too...


> We've lived without it for quite some time, though.

I looked at adding debounce support to the generic GPIO calls
(and thus gpiolib) some time back, but decided against it.  I
forget why at this time (check list archives) but it wasn't because
of lack of utility in certain contexts.

One thing to watch out for is just how variable the hardware
capabilities are.  Atmel GPIOs have something like a fixed number
of 32K clock cycles for debounce, twl4030 had something odd, OMAPs
were more like the Atmel chips but with a different clock.  In some
cases debouncing had to be ganged, not per-GPIO.  And so forth.

- Dave


