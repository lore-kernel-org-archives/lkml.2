Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab0KMRBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 12:01:47 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:34879 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0KMRBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 12:01:45 -0500
Date: Sat, 13 Nov 2010 18:01:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Phil Pokorny <ppokorny@penguincomputing.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] Location for thermal drivers
Message-ID: <20101113180136.2743fb2d@endymion.delvare>
In-Reply-To: <20101113144021.GA29753@ericsson.com>
References: <1289594026.22931.388.camel@groeck-laptop>
	<AANLkTimERGh2yGGX_E_N4ajxg_-0QTFS54QSKj2+AAfF@mail.gmail.com>
	<1289599600.22931.406.camel@groeck-laptop>
	<AANLkTikPt09Xdr_wvjmXhdPD8UdA-7b=AJjC+zgn8PA4@mail.gmail.com>
	<20101113144021.GA29753@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Nov 2010 06:40:21 -0800, Guenter Roeck wrote:
> On Sat, Nov 13, 2010 at 02:21:58AM -0500, Phil Pokorny wrote:
> > Reading the thermal sysfs-api and code, it's seems clear that it is a
> > very ACPI centric kind of thing.  It's involved in the coordination of
> > temperatures and the ways (fans, throttle algorithms, etc.) to keep
> > them in check.  It makes regular calls into the ACPI parser to
> > evaluate values.
> > 
> > But this driver that Alan has written seems to be a hwmon driver.
> > It's poking at registers, setting up A2D channels and dealing with
> > thermistors and perhaps voltages?  Those are very hwmon like things
> > for a driver to do.
> > 
> > It appears to be very similar to the coretemp and k10temp drivers that
> > read temperatures from the internals of the CPU.
>
> If the driver would use the hwmon framework, yes. However, it uses the thermal
> framework, in which hwmon support is optional.
> 
> The thermal framework itself is acpi independent. There is no single
> acpi call in the thermal framework code. acpi use may be true for the 
> drivers currently registering with the thermal framework, but that
> doesn't mean that the thermal framework itself in any way depends on 
> or is only supposed to be used with ACPI devices. ACPI is only referenced
> in the documentation as example.
> 
> If the thermal framework were to be used for acpi devices only, it would
> presumably reside in drivers/acpi and not be independent.
> 
> So your reasoning isn't really correct. Putting thermal drivers into 
> the hwmon directory doesn't really make sense. hwmon functionality
> is an optional subset of thermal drivers, but that does not mean
> that thermal drivers _are_ hwmon drivers.

+1

-- 
Jean Delvare
