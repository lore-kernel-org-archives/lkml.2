Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab0D3RmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:42:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:58917 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933265Ab0D3Rle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:41:34 -0400
Subject: Simple fan question
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: lm-sensors@lm-sensors.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 15:21:46 +1000
Message-ID: <1272518506.24542.163.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

I'm writing some support for d-link dns323 rev C1 NAS. It has a fan that
is controlled by some non-programmable PWM circuit. Basically, all I can
do is tweak to GPIOs that controls the feed into the circuitry for the
fans to be off, slow or fast.

I don't know what the actual PWM values are for "slow" or "fast". I
-might- be able to do some measurements but I can't promise it.

Now I'm trying to do a simple hwmon driver for that in order to easy
userspace support for these guys, and I don't really see a 'nice' way to
expose that which would fit the interfaces documented
Documentation/hwmon/sysfs-interface.

So before I do something horrible, I felt I might poke you guys see if
you have a good idea here :-)

Before I read the above document I was thinking about a sysfs file that
contains "off", "slow" or "fast" but it looks like this won't fit at all
the typical hwmon APIs.

Another comment while at it is when implementing the thermal control for
PowerMacs a while back (windfarm etc...) I had to deal with two
different type of interfaces to fans. RPM controlled and PWM controlled.

The later basically let me program a percentile value (a percent of the
duty cycle).

I looks like the described sysfs interface only does RPM, or at least
doesn't provide a way to expose the units used...

Cheers,
Ben.


