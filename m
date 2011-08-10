Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1HJFhC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 01:37:02 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:37390 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1HJFhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 01:37:00 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Aug 2011 01:36:59 EDT
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Regarding USB-RS485 Cable Manufacturer: FTDI SerialNumber: FTU6Z938
Date: Wed, 10 Aug 2011 10:55:39 +0530
Message-Id: <20110810051603.M89044@admin-gateway.ncra.tifr.res.in>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Greg,
           I have purchased a USB-RS485 Cable Manufacturer: FTDI SerialNumber: FTU6Z938.
And I have written a user space program to communicate with my Rs-485 device at the
other end.The device at the other end expect 1 address byte with mark parity and rest of
the bytes with space parity.


Below is the userspace code which I have used for setting the Mark and Space parity bit.

 // Send the first byte with mark parity-
          attr.c_cflag |= PARENB;
          attr.c_cflag |= CMSPAR;
          attr.c_cflag |= PARODD;
     
        tcsetattr(fd, TCSADRAIN, &attr);
         write(fd, buff, 1); // It writes the address byte 

// Send the rest with space parity

          attr.c_cflag |= PARENB;
          attr.c_cflag |= CMSPAR;
          attr.c_cflag &= ~PARODD;
          tcsetattr(fd, TCSADRAIN, &attr);
           write(fd,buff+1,( length-1));

I can see the Data going out on the Scope when I terminate the userspace program using
Control+ C. But the device at the other end is not responding.

Kindly tell me Whether It can be done from userspace or I have to modify the device driver.


Regards,
Raj.

