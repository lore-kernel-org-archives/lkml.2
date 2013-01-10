Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3AJEM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 23:12:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45054 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791Ab3AJEM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 23:12:56 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "tony@atomide.com" <tony@atomide.com>, "paul@pwsan.com" <paul@pwsan.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH 3/7] pwm: pwm-tiehrpwm: Update the clock handling of
 pwm-tiehrpwm driver
Thread-Topic: [PATCH 3/7] pwm: pwm-tiehrpwm: Update the clock handling of
 pwm-tiehrpwm driver
Thread-Index: AQHN6OyYhnEnPV6atEm/na5feiNykJg1rumAgAFY3DA=
Date: Thu, 10 Jan 2013 04:11:42 +0000
Deferred-Delivery: Thu, 10 Jan 2013 04:11:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA5A510@DBDE01.ent.ti.com>
References: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
 <1357133094-30806-4-git-send-email-avinashphilip@ti.com>
 <20130102133843.GA4414@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130102133843.GA4414@avionic-0098.adnet.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 19:08:43, Thierry Reding wrote:
> On Wed, Jan 02, 2013 at 06:54:50PM +0530, Philip Avinash wrote:
> > The clock framework has changed and it's now better to invoke
> > clock_prepare_enable() and clk_disable_unprepare() rather than the
> > legacy clk_enable() and clk_disable() calls. This patch converts the
> > pwm-tiehrpwm driver to the new framework.
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > Cc: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> > In 3.8-rc1, common clock frame work support added to AM335x.
> > 
> >  drivers/pwm/pwm-tiehrpwm.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
> > index 72a6dd4..af6f162 100644
> > --- a/drivers/pwm/pwm-tiehrpwm.c
> > +++ b/drivers/pwm/pwm-tiehrpwm.c
> > @@ -341,7 +341,7 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> >  	configure_polarity(pc, pwm->hwpwm);
> >  
> >  	/* Enable TBCLK before enabling PWM device */
> > -	clk_enable(pc->tbclk);
> > +	clk_prepare_enable(pc->tbclk);
> 
> I apparently didn't catch this before, but maybe it would be useful to
> check the return value here to make sure we only proceed if the clock
> can actually be enabled.

Ok I will check return value & make it return status of pwm_enable().
I will send it as individual patch in next series. I am waiting for
reviews / acceptance of HWMOD and clock tree node patches.

Thanks
Avinash

> 
> Thierry
> 

