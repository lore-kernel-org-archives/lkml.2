Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab0IHDla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 23:41:30 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:59182 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0IHDlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 23:41:25 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regarding USB-serial device driver
Date: Wed, 8 Sep 2010 09:11:19 +0530
Message-Id: <20100908034006.M11954@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20100907114913.M69542@admin-gateway.ncra.tifr.res.in>
References: <20100907061327.M12473@admin-gateway.ncra.tifr.res.in> <20100907065937.GA22307@suse.de> <20100907114913.M69542@admin-gateway.ncra.tifr.res.in>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Wierd.  If you enable debugging in the driver:
> 	modprobe pl2303 debug=1
> do you also see the kernel log showing extra data going out to the host?
> 
> What is your userspace program doing?  Are you sure you are only writing
> 6 bytes?  The bulk out should only be writing the actual data in the
> buffer, not any more than that.
> 
> Do you have an example userspace code that we can use to test with?
> 
> thanks,
> 
> greg k-h

Greg, 
      I am really sorry, that superfluous data was due to user space program.I have
modified that.Now I am able to send correct data to the device. 5e and 40 is also going
out.I don't know from where it is coming.
But I am not getting the response.

output of usbmon :

ee9e1680 4108443204 C Co:7:003:0 0 0
f6e80c00 4108443237 S Bo:7:003:2 -115 9 = 05080000 00000000 f8 // correct data bytes 
f6e80c00 4108444202 C Bo:7:003:2 0 9 >
ee9e1680 4108448251 S Co:7:003:0 s 21 22 0000 0000 0000 0
ee9e1680 4108449202 C Co:7:003:0 0 0
f6e80700 4108450204 C Bi:7:003:3 0 1 = 00
ee9e1680 4108450546 S Co:7:003:0 s 21 22 0003 0000 0000 0
f6e80900 4108451204 C Ii:7:003:1 0:1 10 = a1200000 00000200 0400
f6e80900 4108451223 S Ii:7:003:1 -115:1 10 <
ee9e1680 4108451227 C Co:7:003:0 0 0
f6e80c00 4108451252 S Bo:7:003:2 -115 1 = 5e // don't know from where it is going out 
f6e80c00 4108452201 C Bo:7:003:2 0 1 >
f6e80900 4108453203 C Ii:7:003:1 0:1 10 = a1200000 00000200 0000
f6e80900 4108453221 S Ii:7:003:1 -115:1 10 <
ee9e1680 4108456262 S Co:7:003:0 s 21 22 0000 0000 0000 0
ee9e1680 4108457202 C Co:7:003:0 0 0
ee9e1680 4108457225 S Co:7:003:0 s 21 22 0003 0000 0000 0
ee9e1680 4108458201 C Co:7:003:0 0 0
f6e80c00 4108458228 S Bo:7:003:2 -115 1 = 40 // don't know from where it is going out 
f6e80c00 4108459201 C Bo:7:003:2 0 1 >
ee9e1680 4108463235 S Co:7:003:0 s 21 22 0000 0000 0000 0
ee9e1680 4108464204 C Co:7:003:0 0 0

Regards,
Raj.

