Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1F3RCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:02:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47659 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1F3RCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:02:33 -0400
Date: Thu, 30 Jun 2011 19:02:29 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Message-ID: <20110630170229.GP6069@pengutronix.de>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de>
 <1309430517-23821-2-git-send-email-s.hauer@pengutronix.de>
 <BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com>
 <201106301441.24493.arnd@arndb.de>
 <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:33:52 up 8 days, 22:21, 31 users,  load average: 0.48, 0.44, 0.35
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill,

On Thu, Jun 30, 2011 at 11:17:54AM -0500, Bill Gatliff wrote:
> Guys:
> 
> On Thu, Jun 30, 2011 at 7:41 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > A lot of people want to see a framework get merged, and I think it's
> > great that Sascha has volunteered to do the work to push that
> > through this time, especially since you have not been able to
> > finish your work.
> 
> Sascha is wasting his time by reinventing the wheel.  He's traveling
> over exactly the same path I have already covered.  In fact, some of
> his reviewer comments are almost word-for-word the same as those I
> have received and addressed in the past.
> 
> My patches were always kept current in this mailing list and others,
> and Sascha clearly has the skills necessary to make improvements and
> corrections should he have chosen to do so.

I think that you made the fundamental mistake to completly ignore the
existing pwm API and its users. With a competing api we are basically
stuck. We can't convert the existing hardware drivers to the new API
because leds-pwm.c, pwm_bl.c and others still depend on the old API and
boards using it would break. We can't convert the function drivers
either because again this would break boards for which only an old style
pwm driver exists.  So the logical thing to do is to put a step in
between: Consolidate the existing drivers and *then* change the API
atomically so that nothing breaks. Your patches don't do this, so I
don't think at all that what I did is duplication of work.

Given the current rush to move drivers out of arch/ it probably won't
take long until all pwm drivers are moved to drivers/pwm/ and converted
to use the framework, and then you have a good base to put your work onto.
So please don't complain too much: We are currently only doing the work
you didn't want to do.


Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
