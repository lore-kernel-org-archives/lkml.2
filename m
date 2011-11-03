Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116Ab1KCQnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:43:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:48254 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934024Ab1KCQn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:43:29 -0400
Date: Thu, 3 Nov 2011 17:43:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Lars =?ISO-8859-1?B?Tm9vZOlu?= <lars.nooden@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Hardware running hot and without the fan
Message-ID: <20111103174321.37274532@endymion.delvare>
In-Reply-To: <1320334322.2309.68.camel@groeck-laptop>
References: <4EB1108F.6070009@gmail.com>
	<20111103020301.GA22333@ericsson.com>
	<4EB250FD.3070000@gmail.com>
	<20111103134902.GA26121@ericsson.com>
	<4EB2A46B.8080600@gmail.com>
	<1320332801.2309.60.camel@groeck-laptop>
	<4EB2B0FD.309@gmail.com>
	<1320334322.2309.68.camel@groeck-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011 08:32:02 -0700, Guenter Roeck wrote:
> On Thu, 2011-11-03 at 11:19 -0400, Lars Noodén wrote:
> > I can set the fan speed manually.  e.g.:
> > 
> >  echo 3500 > /sys/class/hwmon/hwmon0/device/fan1_output
> > 
> > That helps some.
> > 
> If you can do that, you should be able to set up fancontrol to
> automatically control fan speed based on system temperatures.

This won't work, as fancontrol wants pwmX attributes which the applesmc
driver doesn't implement.

> There is another sysfs attribute - fanX_manual. I don't find driver
> documentation, so I have no idea what it is doing. The name indicates
> that it might set manual vs. automatic fan control. What is it set to in
> your system ? From the code, looks like it should be 0 or 1. Try to
> toggle it and see what happens - after all, it can not get worse ;).

Might be worth looking at files fanX_min, _max and _safe too. Too bad
there doesn't seem to be any documentation available for all these
non-standard attributes :(

-- 
Jean Delvare
