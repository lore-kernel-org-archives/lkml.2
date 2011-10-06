Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965126Ab1JFQ0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:26:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53557 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935856Ab1JFQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:25:59 -0400
Date: Thu, 6 Oct 2011 21:55:40 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a
 device number
Message-ID: <20111006162540.GA5402@ubuntu.ubuntu-domain>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <1317839407.3983.46.camel@groeck-laptop>
 <20111006040656.GA2125@ubuntu.ubuntu-domain>
 <20111006051955.GA22835@ericsson.com>
 <20111006094302.71ea4dfd@endymion.delvare>
 <20111006151232.GA3267@ubuntu.ubuntu-domain>
 <20111006164600.071213e1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006164600.071213e1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 04:46:00PM +0100, Alan Cox wrote:

> 
> I guess I don't see why a device that is more than just a monitoring
> interface can't allocate a misc device or similar if it needs one.
>

Hi Alan,

For a device, for example, /sys/class/hwmon/hwmon0/dev, mdev will create
hwmon0 named device in /dev. User space apps will access the device
with the same name, i.e. /dev/hwmon0. If a driver registers with hwmon
class and with miscellaneous as well, two entries with same name will
be created under /sys; causing conflict. hwmon will create hwmon%d, you
don't have control over that. So the driver has to make sure that it
gives the same device a different name. Why? Doesn't make sense.
If you want to have hwmon device and still want to have char interface,
isn't doing it all at one place more sensible?

May be this interface is not a necessity but it does provides a flexible
way of achieving what I am talking about.

-Himanshu
