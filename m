Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0IJUzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 16:55:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:52860 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0IJUzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 16:55:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: Voltage/current/sensor monitoring interface and Wiegand
Date: Fri, 10 Sep 2010 20:47:13 +0000 (UTC)
Message-ID: <loom.20100910T224602-978@post.gmane.org>
References: <20100909000245.GK14056@atomos.longlandclan.yi.org> <4C884AFA.20604@bluewatersys.com> <20100909050137.GR14056@atomos.longlandclan.yi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 129.192.170.250 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100825 Ubuntu/10.04 (lucid) Firefox/3.6.9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stuart Longland <redhatter <at> gentoo.org> writes:

> 
> On Thu, Sep 09, 2010 at 02:48:26PM +1200, Ryan Mallon wrote:
> > On 09/09/2010 12:02 PM, Stuart Longland wrote:
> > > How are voltage *monitors* normally written?  (note, not voltage
> > > *regulators*... this thing does not alter the voltage rails.)  I tried
> > > to make sense of lm-sensors, but that seems very ad-hoc (maybe I missed
> > > some document that explains it) to me.  It's hard to be clear on what is
> > > the *right* way to report a voltage or current reading to userspace.
> > 
> > Depending on your particular application it might make sense to use the
> > power supply class (see Documentation/power/power_supply_class.txt) for
> > the voltage/current monitoring. If the temperature sensor is related to
> > a power supply monitor, then it could also go there.
> 
> Ahh okay, I'll have a look there..  The temperature isn't related to the
> power supply, so I might continue a searchfor its rightful place, but
> that class of devices seems like a good fit.

For voltage, current, and temperature monitoring, you should really look into
using using hwmon. The power supply class doesn't make sense to me, unless you
are actually monitoring a power supply and not a voltage. For multi-function
devices, you might also want to look into mfd for higher level access control.

If you have problems understanding what needs to be done, feel free to get in
touch. If the sysfs ABI is insufficient for your needs, just drop an e-mail to
the lm-sensors mailing list. Easier to extend an existing ABI than to write a
new one.

Guenter


