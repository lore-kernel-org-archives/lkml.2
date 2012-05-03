Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2ECKeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:34:46 -0400
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:43315
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754407Ab2ECKeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:34:44 -0400
X-Greylist: delayed 1085 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2012 06:34:44 EDT
From: Johan Hovold <jhovold@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH 1/4] mfd: add LM3533 lighting-power core driver
Date: Thu,  3 May 2012 12:15:19 +0200
Message-Id: <1336040119-13200-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <20120426124122.GA26692@sirena.org.uk>
References: <20120426124122.GA26692@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry for the resend -- Android/gmail apparently added HTML to my previous
  attempt. ] 

On Apr 26, 2012 2:41 PM, "Mark Brown" <broonie@opensource.wolfsonmicro.com>
wrote:
> On Fri, Apr 20, 2012 at 05:30:23PM +0200, Johan Hovold wrote:
> > +static int __lm3533_read(struct lm3533 *lm3533, u8 reg, u8 *val)
> > +{
> > +     int ret;
> > +
> > +     ret = lm3533->read(lm3533, reg, val);
> > +     if (ret < 0) {
>
> Looks like you could save a bunch of code by using regmap for the
> register I/O.  This would also give you access to the cache and
> diagnostic infrastructure it has.

Using regmap only saves about ten lines for the actual io implementation,
but it does allow me to get rid of the custom debugfs interface. I'm not
enabling caching at this point but it'll probably come in handy later.

Thanks,
Johan
