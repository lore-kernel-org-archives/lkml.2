Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0EUNOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:14:17 -0400
Received: from n3-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.156]:31360 "HELO
	n3-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753769Ab0EUNOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:14:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 563176.31392.bm@omp122.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=DdhlJoimSWTVwfewZpOnaOsoS8SnzwIoSb5sBz2+g6m1izzggOny87Sh7jz87VirHxj2M2MyRe2YpeVqw6TDdQX4IjGBVBL836/AJ2WwLJ5mmLmh7Jy0fSqbU4lVPZjNlpo0FJRoVxyQbYeO8myvyMm4vYGF4qrEvAVs6gMlOko=;
Message-ID: <396934.73027.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: YFxWqwkVM1lUOTAflBaPBF13GbyvkfiNoHE84lSt6ZYdVUq
 0MeLK1Weyxj2u69dlxJyKr4_YfsFGqco3WzhgBKxP7.wNYEUI66ueQwhAbi8
 Ix7qz6hxpnDyIlVnv.C1jdAoG0lP7uO2u2ilhGmlHf8._4hTGj9Dy8qlXeg_
 4YlqSFiZHx7RRiaZ42waJ1w5ywBlwr6t3tFCwhJfQ.Y_rRL8Tam0aY6WjMah
 zb74gGCv._kDYZQJK1kvl4hR88MF14xzjWZR4Pyl.bMy6xHqdrMJy2cX93Di
 XcSfJ72XO_Z9aGYCCUq5WxVvNRcFerHBpWfkoNXEpno4FNGTFqCgFKuVyoGQ
 1JC8zY_Tztp1FzK9UfwID.2uMBsJO
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Fri, 21 May 2010 06:14:14 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
To: felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100521111136.53dba6c9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




--- On Fri, 5/21/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:


> GPIO is almost always fairly tightly platform bound

Not entirely.  SOC based ones, yes.  But GPIOs on expanders
and ancillary chips have more variable capabilities, and many
SOC-based boards have a bunch of those.

> so features only
> existing on certain ports is fine. The platform vendor will
> have made
> sure they relevant ports have suitable debounce
> facilities.

One of the earlier examples of why to want debouncing (in the
original discussion, not this one) was for buttons (one signal
per button press) and the hardware designers don't necessarily
hook buttons up to only GPIOs with hardware debounce.  So code
to kick in debounce there needed to be sensitive to whether or
not the capability was available ... and moreover, whether the
debounce scale was adequate to compensate the contact chatter.
When not, then software debounce was inescapable.


