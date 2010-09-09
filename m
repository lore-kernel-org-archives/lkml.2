Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab0IIMiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:38:21 -0400
Received: from ppsw-30.csi.cam.ac.uk ([131.111.8.130]:56742 "EHLO
	ppsw-30.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0IIMiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:38:18 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C88D668.7030501@jic23.retrosnub.co.uk>
Date: Thu, 09 Sep 2010 13:43:20 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Stuart Longland <redhatter@gentoo.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Voltage/current/sensor monitoring interface and Wiegand
References: <20100909000245.GK14056@atomos.longlandclan.yi.org>
In-Reply-To: <20100909000245.GK14056@atomos.longlandclan.yi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

....
> 
> How are voltage *monitors* normally written?  (note, not voltage
> *regulators*... this thing does not alter the voltage rails.)  I tried
> to make sense of lm-sensors, but that seems very ad-hoc (maybe I missed
> some document that explains it) to me.  It's hard to be clear on what is
> the *right* way to report a voltage or current reading to userspace.
typically hwmon, documentation is under /Documentation/hwmon/sysfs-interface.
> 
> For the temperature and light sensing... temperature sensors certainly
> exist in the PC world, and maybe I should look closely at how they are
> normally done, but I wasn't sure about the light sensor.  I was thinking
> maybe an input device with some new absolute value reported?
Light sensing options are currently either /misc or /staging/iio/light.

There are several different interfaces unfortunately.  IIO can work with
a bridge (via uinput) to generate input events is that is what you need.
The interface is still a bit unstable, though it is getting cleaned up
at the moment.
> 
> Likewise with the PIR sensor, I notice there's a "gesture" input
> (MSC_GESTURE)... seems appropriate?  Or am I barking up the wrong tree?
Does it look like a button (e.g. is it a straight on off device with
no control parameters etc)? Dmitry, what would you put this as and would
this be acceptable in input?  
