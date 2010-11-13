Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0KMOlK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:41:10 -0500
Received: from imr3.ericy.com ([198.24.6.13]:50244 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab0KMOlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:41:07 -0500
Date: Sat, 13 Nov 2010 06:40:21 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Phil Pokorny <ppokorny@penguincomputing.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] Location for thermal drivers
Message-ID: <20101113144021.GA29753@ericsson.com>
References: <1289594026.22931.388.camel@groeck-laptop>
 <AANLkTimERGh2yGGX_E_N4ajxg_-0QTFS54QSKj2+AAfF@mail.gmail.com>
 <1289599600.22931.406.camel@groeck-laptop>
 <AANLkTikPt09Xdr_wvjmXhdPD8UdA-7b=AJjC+zgn8PA4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikPt09Xdr_wvjmXhdPD8UdA-7b=AJjC+zgn8PA4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 02:21:58AM -0500, Phil Pokorny wrote:
> On Fri, Nov 12, 2010 at 2:06 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > On Fri, 2010-11-12 at 16:53 -0500, Phil Pokorny wrote:
> >> On Fri, Nov 12, 2010 at 12:33 PM, Guenter Roeck
> >> <guenter.roeck@ericsson.com> wrote:
> >> > I think a better location for the driver would be drivers/thermal.
> >> > drivers/hwmon is not really a good fit, since hwmon support for thermal
> >> > drivers is optional.
> >>
> >> What is the difference between a "thermal" sensor and a "temperature"
> >> sensor?  Aren't they the same thing?
> >>
> > The thermal framework is much more extensive than the hwmon framework.
> > See Documentation/thermal/sysfs-api.txt for details.
> 
> Ahh...  Sorry for wasting your time without reading the necessary
> background first.  I have rectified this oversight.
> 
> Reading the thermal sysfs-api and code, it's seems clear that it is a
> very ACPI centric kind of thing.  It's involved in the coordination of
> temperatures and the ways (fans, throttle algorithms, etc.) to keep
> them in check.  It makes regular calls into the ACPI parser to
> evaluate values.
> 
> But this driver that Alan has written seems to be a hwmon driver.
> It's poking at registers, setting up A2D channels and dealing with
> thermistors and perhaps voltages?  Those are very hwmon like things
> for a driver to do.
> 
> It appears to be very similar to the coretemp and k10temp drivers that
> read temperatures from the internals of the CPU.
> 
If the driver would use the hwmon framework, yes. However, it uses the thermal
framework, in which hwmon support is optional.

The thermal framework itself is acpi independent. There is no single
acpi call in the thermal framework code. acpi use may be true for the 
drivers currently registering with the thermal framework, but that
doesn't mean that the thermal framework itself in any way depends on 
or is only supposed to be used with ACPI devices. ACPI is only referenced
in the documentation as example.

If the thermal framework were to be used for acpi devices only, it would
presumably reside in drivers/acpi and not be independent.

So your reasoning isn't really correct. Putting thermal drivers into 
the hwmon directory doesn't really make sense. hwmon functionality
is an optional subset of thermal drivers, but that does not mean
that thermal drivers _are_ hwmon drivers.

Guenter
