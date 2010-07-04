Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0GDQTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 12:19:32 -0400
Received: from a.ns.protobalance.com ([95.211.116.249]:41772 "EHLO
	protonet.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840Ab0GDQTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 12:19:31 -0400
Subject: patch? Re: USB mass storage fails to register on kernel 2.6.32
From: Paul Sheer <p@2038bug.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1278230583.6443.27.camel@localhost>
References: <1278230583.6443.27.camel@localhost>
Content-Type: text/plain
Date: Sun, 04 Jul 2010 18:05:21 +0200
Message-Id: <1278259521.7623.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I changed the cable and it works perfectly.

I suggest the following patch then:

--- ./drivers/usb/core/hub.c 2010-06-11 09:54:26.000000000 +0200
+++ ./drivers/usb/core/hub.c.new 2010-07-04 17:10:28.000000000 +0200
@@ -2777,12 +2777,12 @@
retval = -ENODEV;
goto fail;
}
if (r) {
dev_err(&udev->dev,
- "device descriptor read/64, error %d\n",
- r);
+ "device descriptor read/64, error %d%s\n",
+ r, r == -32 ? ": bad cable?" : "");
retval = -EMSGSIZE;
continue;
}
#undef GET_DESCRIPTOR_BUFSIZE
}

I guess this closes this issue.

Kind regards

-paul


On Sun, 2010-07-04 at 10:03 +0200, Paul Sheer wrote:
> Hi there,
> 
> I have a Samsung Story external USB-2.0 1.5TB drive that fails to
> detect as a device in more recent kernel versions. Full kmsg details
> are below. Note that a USB thumb drive works fine on my system.
> Older kernels work fine with the Samsung also. In terms of which
> version of the kernel this stopped working, this I don't know.
> 


