Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2GWPGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:06:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44899 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab2GWPGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:06:32 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH] PWM: Add support for configuring polarity of PWM
Thread-Topic: [PATCH] PWM: Add support for configuring polarity of PWM
Thread-Index: AQHNZOZ2DrTfmztun0iwJK4BcEJ8xpc2NNgAgABp63D//+O5gIAAXLlg
Date: Mon, 23 Jul 2012 15:05:26 +0000
Deferred-Delivery: Mon, 23 Jul 2012 15:05:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E971AE3@DBDE01.ent.ti.com>
References: <1342616053-7793-1-git-send-email-avinashphilip@ti.com>
 <20120723083032.GA12868@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E97189D@DBDE01.ent.ti.com>
 <20120723130825.GA21254@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120723130825.GA21254@avionic-0098.mockup.avionic-design.de>
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

On Mon, Jul 23, 2012 at 18:38:25, Thierry Reding wrote:
> On Mon, Jul 23, 2012 at 12:51:11PM +0000, Philip, Avinash wrote:
> > On Mon, Jul 23, 2012 at 14:00:32, Thierry Reding wrote:
> > > On Wed, Jul 18, 2012 at 06:24:13PM +0530, Philip, Avinash wrote:
> [...]
> > > > +
> > > > +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> > > > +		dev_err(pwm->chip->dev,
> > > > +			"Polarity configuration Failed!, PWM device enabled\n");
> > > > +		return -EBUSY;
> > > > +	}
> > > 
> > > Maybe something like: "polarity cannot be configured while PWM device is
> > > enabled"?
> > 
> > Ok I will update.
> > 
> > > Though I'm not sure the error message is all that useful. I'd
> > > expect the user driver to handle -EBUSY specially.
> > 
> > On EBUSY, client driver has to rework on it. Nothing to be done from
> > framework
> 
> Exactly, so I think that if an error is displayed because the PWM has
> been enabled, then that client (== user) driver should output an error
> message, not the framework. Also, it really shouldn't happen because it
> clearly is a driver problem that needs to be fixed.

Ok. I will remove.

> 
> > > >  /*
> > > >   * pwm_enable - start a PWM output toggling
> > > >   */
> > > > @@ -37,6 +47,7 @@ struct pwm_chip;
> > > >  enum {
> > > >  	PWMF_REQUESTED = 1 << 0,
> > > >  	PWMF_ENABLED = 1 << 1,
> > > > +	PWMF_POLARITY_INVERSE = 1 << 2,
> > > 
> > > This should be named PWMF_POLARITY_INVERSED for consistency.
> > 
> > Ok I will correct it.
> > 
> > > I'm not sure that we really need this flag, though. It isn't used anywhere. But
> > > maybe you have a use-case in mind?
> > 
> > It can be used to find the polarity of the PWM at runtime.
> 
> Yes, but is there any use-case where this information would be required?

It's been added as a feature enhancement. May be it can ignore?


Thanks
Avinash

> 
> Thierry
> 

