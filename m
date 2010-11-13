Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab0KMHWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 02:22:01 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:43544 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751185Ab0KMHWA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 02:22:00 -0500
MIME-Version: 1.0
In-Reply-To: <1289599600.22931.406.camel@groeck-laptop>
References: <1289594026.22931.388.camel@groeck-laptop>
	<AANLkTimERGh2yGGX_E_N4ajxg_-0QTFS54QSKj2+AAfF@mail.gmail.com>
	<1289599600.22931.406.camel@groeck-laptop>
Date: Fri, 12 Nov 2010 23:21:58 -0800
Message-ID: <AANLkTikPt09Xdr_wvjmXhdPD8UdA-7b=AJjC+zgn8PA4@mail.gmail.com>
Subject: Re: [lm-sensors] Location for thermal drivers
From: Phil Pokorny <ppokorny@penguincomputing.com>
To: guenter.roeck@ericsson.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 2:06 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> On Fri, 2010-11-12 at 16:53 -0500, Phil Pokorny wrote:
>> On Fri, Nov 12, 2010 at 12:33 PM, Guenter Roeck
>> <guenter.roeck@ericsson.com> wrote:
>> > I think a better location for the driver would be drivers/thermal.
>> > drivers/hwmon is not really a good fit, since hwmon support for thermal
>> > drivers is optional.
>>
>> What is the difference between a "thermal" sensor and a "temperature"
>> sensor?  Aren't they the same thing?
>>
> The thermal framework is much more extensive than the hwmon framework.
> See Documentation/thermal/sysfs-api.txt for details.

Ahh...  Sorry for wasting your time without reading the necessary
background first.  I have rectified this oversight.

Reading the thermal sysfs-api and code, it's seems clear that it is a
very ACPI centric kind of thing.  It's involved in the coordination of
temperatures and the ways (fans, throttle algorithms, etc.) to keep
them in check.  It makes regular calls into the ACPI parser to
evaluate values.

But this driver that Alan has written seems to be a hwmon driver.
It's poking at registers, setting up A2D channels and dealing with
thermistors and perhaps voltages?  Those are very hwmon like things
for a driver to do.

It appears to be very similar to the coretemp and k10temp drivers that
read temperatures from the internals of the CPU.

I vote for hwmon rather than drivers/thermal...

Phil P.
