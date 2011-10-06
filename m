Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998Ab1JFPsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:48:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51456 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420Ab1JFPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:48:35 -0400
Date: Thu, 6 Oct 2011 16:46:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Himanshu Chauhan <hschauhan@nulltrace.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a
 device number
Message-ID: <20111006164600.071213e1@lxorguk.ukuu.org.uk>
In-Reply-To: <20111006151232.GA3267@ubuntu.ubuntu-domain>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
	<1317839407.3983.46.camel@groeck-laptop>
	<20111006040656.GA2125@ubuntu.ubuntu-domain>
	<20111006051955.GA22835@ericsson.com>
	<20111006094302.71ea4dfd@endymion.delvare>
	<20111006151232.GA3267@ubuntu.ubuntu-domain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> AFAIK, the current sysfs interface is to read standard attributes from
> the device. My reasoning is:

and any other attributes.

> 1. This will give hwmon devices to have their "dev" in their sysfs folder
>    as like other classes and in turn be visible in /dev by mdev or udev.

Well there is in theory no reason a device shouldn't do that, but most
sysfs devices don't need to so making it generic seems odd.

> 2. Implementing IOCTL if required. I know that kernel hackers believe
>    they are "backdoors" and "can't be done right" but sometimes there
>    isn't any get away with them. I don't know when their support will
>    be completely removed. Rather, I see that instead of deprecation,
>    new IOCTL vectors like compat_ioctl have been introduced.

Certain things need ioctl, in fact some problems are *very* hard to
solve any other way: transactional updates (changing a set of fields at
once all or none), and query/response data being two.
 
> 2. During probing, for each device, call "hwmon_device_register_numbered"
>    and let mdev create a /dev node for it. I don't say that this interface
>    be imposed on drivers. If they want they can still call "hwmon_device_register"
>    if they don't want to implement standard ioctl, read, write calls.

I guess I don't see why a device that is more than just a monitoring
interface can't allocate a misc device or similar if it needs one.

For the more complex cases take a look at drivers/staging/iio also.
