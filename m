Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0KDXB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 19:01:59 -0400
Received: from bsmtp5.bon.at ([195.3.86.187]:53440 "EHLO lbmfmo03.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751015Ab0KDXB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 19:01:57 -0400
X-Greylist: delayed 1737 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 19:01:57 EDT
Subject: Device driver model: how to bind platform device to driver
 manually?
From: Peter Gsellmann <pgsellmann@portner-elektronik.at>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: PORTNER-Elektronik
Date: Thu, 04 Nov 2010 23:32:16 +0100
Message-ID: <1288909936.17122.74.camel@aspire.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my board-specific initialization, i have registered platform devices
 with resources and names so they are not bound automatically to any
 default platform drivers (intentionally).

Later on, i install the platform driver candidates as kernel modules
 with platform_driver_register().

Now the problem: how to trigger the mydriver_probe() function with the
 correct platform device?

I see 2 possible solutions:

1.
echo 'platform:mydevice' > /sys/bus/platform/mydriver/bind

2.
echo 'bindinginfo' > /sys/bus/platform/drivers_probe

Which of the two is the correct (canonical) one?
Is there a third option?
The strings 'platform:mydevice' , 'bindinginfo' are obviously wrong.
 What to echo instead?
Is there documentation beside ./Documentation/driver-model/*.txt ?


My platform device is visible as /sys/devices/platform/mydevice/ with
 files modalias, uevent and also in /proc/iomem
My platform driver is visible as /sys/bus/platform/mydriver/ with
 files bind, unbind, uevent.


TIA,
Peter Gsellmann

