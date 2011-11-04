Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1KDKqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:46:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55300 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1KDKqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <1320339328.2309.78.camel@groeck-laptop>
References: <4EB1108F.6070009@gmail.com>
	<20111103020301.GA22333@ericsson.com>
	<4EB250FD.3070000@gmail.com>
	<20111103134902.GA26121@ericsson.com>
	<4EB2A46B.8080600@gmail.com>
	<1320332801.2309.60.camel@groeck-laptop>
	<4EB2B0FD.309@gmail.com>
	<1320334322.2309.68.camel@groeck-laptop>
	<20111103174321.37274532@endymion.delvare>
	<1320339328.2309.78.camel@groeck-laptop>
Date: Fri, 4 Nov 2011 13:46:44 +0300
Message-ID: <CACq_q0eru4AOgV9Km5PqXPUDUVWphxFeZPFkwR5cJzPbkz7PCQ@mail.gmail.com>
Subject: Re: [lm-sensors] Hardware running hot and without the fan
From: lars nooden <lars.nooden@gmail.com>
To: guenter.roeck@ericsson.com
Cc: Jean Delvare <khali@linux-fr.org>, Henrik Rydberg <rydberg@euromail.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/11, Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> On Thu, 2011-11-03 at 12:43 -0400, Jean Delvare wrote:
>> On Thu, 3 Nov 2011 08:32:02 -0700, Guenter Roeck wrote:
>> > On Thu, 2011-11-03 at 11:19 -0400, Lars Noodén wrote:
>> > > I can set the fan speed manually.  e.g.:
>> > >
>> > >  echo 3500 > /sys/class/hwmon/hwmon0/device/fan1_output
>> > >
>> > > That helps some.
>> > >
>> > If you can do that, you should be able to set up fancontrol to
>> > automatically control fan speed based on system temperatures.
>>
>> This won't work, as fancontrol wants pwmX attributes which the applesmc
>> driver doesn't implement.
>>
> Yes, you are right - it won't work without patching it to use
> fanX_output and to accept larger values for the limits.
>
> Wonder how this works for other Apple systems. Maybe there is an
> Apple-specific script out there to control fan speed.
>
>> > There is another sysfs attribute - fanX_manual. I don't find driver
>> > documentation, so I have no idea what it is doing. The name indicates
>> > that it might set manual vs. automatic fan control. What is it set to in
>> > your system ? From the code, looks like it should be 0 or 1. Try to
>> > toggle it and see what happens - after all, it can not get worse ;).
>>
>> Might be worth looking at files fanX_min, _max and _safe too. Too bad
>> there doesn't seem to be any documentation available for all these
>> non-standard attributes :(
>>
> Here is some info from the web about the problem. See
> http://ubuntuforums.org/archive/index.php/t-981280.html.
>
> So, for those that have reported high temperatures due to low fan
> speeds: check the value of
>
> cat /sys/devices/platform/applesmc.768/fan1_manual

It is zero already:
  $ cat /sys/devices/platform/applesmc.768/fan1_manual
  0

/Lars

> With no software control of the fans, which is the case with the
> macbooks (fancontrol and pwmconfig does not work), the fan speed seems
> to be controlled automatically by the SMC without issues - but only if
> fan1_manual is zero.
>
> Guenter
>
>
>
