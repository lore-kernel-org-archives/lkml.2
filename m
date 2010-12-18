Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0LRMzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 07:55:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37301 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab0LRMzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 07:55:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Date: Sat, 18 Dec 2010 13:54:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Rabin Vincent <rabin@rab.in>, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com> <201012180001.25263.rjw@sisk.pl> <20101218010454.GA2430@opensource.wolfsonmicro.com>
In-Reply-To: <20101218010454.GA2430@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012181354.58077.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 18, 2010, Mark Brown wrote:
> On Sat, Dec 18, 2010 at 12:01:25AM +0100, Rafael J. Wysocki wrote:
> > On Friday, December 17, 2010, Mark Brown wrote:
> 
> > > 	if (pm) {
> > > 		if (pm_runtime_suspended(dev))
> > > 			return 0;
> > > 		else
> > > 			return pm->suspend ? pm->suspend(dev) : 0;
> > > 	}
> 
> > > 	return i2c_legacy_suspend(dev, PMSG_SUSPEND);
> > > }
> 
> > > Ideally the if (pm) block could just be factored out into the pm core as
> > > there's nothing I2C-specific about that at all.  Possibly even the whole
> > > logic surrounding fall back to legacy, though that smells a bit.
> 
> > No, the legacy is i2c-specific.
> 
> SPI and platform (the first two buses I looked at) both seem to have
> legacy suspend operations too?  Clearly the bus would need to provide an
> op to invoke the legacy call but the logic which prioritises the pm_ops
> over the legacy operation is generic.

Well, the problem with that is the driver would need to tell the generic call
what the legacy routine is and there's no, er, generic way to do that.

In the i2c case, for example, there is struct i2c_driver that contains the
->suspend() and ->resume() pointers, so the bus type driver _knows_ how to
get there, but the PM core doesn't have this information.

Thanks,
Rafael
