Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0LWChD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 21:37:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49167 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752482Ab0LWChB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 21:37:01 -0500
Date: Thu, 23 Dec 2010 02:36:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH v2 5/6] MFD MAX8998/LP3974: Charger Support
Message-ID: <20101223023659.GC25886@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com> <1292998991-26968-6-git-send-email-myungjoo.ham@samsung.com> <20101222133359.GF26306@opensource.wolfsonmicro.com> <AANLkTimhfUTD0ze8VaBz9BtkuEMx9sutc-1VvsXfH-ot@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimhfUTD0ze8VaBz9BtkuEMx9sutc-1VvsXfH-ot@mail.gmail.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 11:10:41AM +0900, MyungJoo Ham wrote:
> On Wed, Dec 22, 2010 at 10:33 PM, Mark Brown
> > On Wed, Dec 22, 2010 at 03:23:10PM +0900, MyungJoo Ham wrote:

> > Normally I'd expect a battery charger to be exposed via the power supply
> > API - I'd at least expect to see a consumer in the power supply API

> The "CHARGER" regulator is to give the charger control to the user,
> which consists of switching (turn on/off) and current limit, which is
> what a current regulator does. On the contrary, when the charger
> control is implemented by power supply API, we do not have explicit
> control over such features (current limit and turn on/off).

Sure, like I say I'd just expect to see some power supply API visibility
- that could be a driver that provides the control that's needed to
userspace by controlling a current regulator, for example.

> Furthermore, a board may need to support multiple types of
> charger(USB, ACDC-5V-2A, ACDC-5V-1A, ...), which have various current
> limits. Thus, we need to adjust charger current limit out of PMIC
> driver unless the PMIC can detect every type of supported chargers,
> which MAX8998/LP3974 cannot.

Interesting system design - I've not seen that before.  With the system
designs I usually look at the current limiting from the wall/charger
supply is done on the primary system power rail which supplies both
thehcarger and the rest of the system (since the current drains from the
rest of the system also needs to be limited).  Similarly for the
temperature monitoring, I've usually seen that managed by hardware.

> That's why I have implemented charger in regulator framework. In the
> environment described above, the power supply consumer is going to be
> implemented over PMIC driver, USB/TA select driver (e.g., FSA9480),
> and Thermistor driver (e.g., NTC Thermistor). It appears that such a
> consumer driver is going to be a board or policy specification; (or
> full or callbacks that is going to be filled by a mach/board file)

I agree - it'd be a bit like the current GPIO power supply driver, I
think.  It'd probably also specify things like callbacks for voltage
monitoring via auxiliary ADCs in the PMIC or CPU.  My main point was
that it was surprising that the regulator driver for the charger didn't
come along with such a consuner driver, the split does make sense.
