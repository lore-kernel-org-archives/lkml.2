Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab0K3BwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 20:52:18 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62885 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0K3BwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 20:52:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JWBeOv0RljGLdb23Gp882Z4hXUuiP8uhwQaslkZA8LNScvJyvtUXYQ1rDaozvA1mwX
         HcQcjmsyxZzgieOqN2exBstLv59lubPPreb6msCp1goUNJq+in4JobP51Sccs3um/15e
         9Yh4mjF6JZs3tEPMAURCq2k0cDJiXmFm6CljI=
Message-ID: <4CF458CE.2050603@gmail.com>
Date: Mon, 29 Nov 2010 20:52:14 -0500
From: Benjamin Poirier <benjamin.poirier@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Johan Hovold <jhovold@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andreas Mohr <andi@lisas.de>,
        Daniel Sangorrin <daniel.sangorrin@gmail.com>,
        linux-usb@vger.kernel.org
Subject: BUG, regression. usb-serial adapter broken by PM?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Recently, my usb-serial converter has become unusable. Attempts to open
the device always fail with:
open("/dev/ttyUSB0", O_RDONLY)          = -1 EAGAIN (Resource temporarily unavailable)

The device is a:
ID 0c52:2101 Sealevel Systems, Inc. Serial Converter
and uses the ftdi_sio driver.

I've bisected this problem to
commit 1bfee5bc86fdaecc912e06080583eddab7263df2
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Sat Sep 25 23:35:00 2010 +0200

    PM / Runtime: Merge synchronous and async runtime routines

I have other usb-serial converters that use other drivers and that are
unaffected. I have noticed the problem on a x86_64 machine (.config
here: http://pastebin.ca/2006414) and can reproduce it in kvm (with usb
passthrough, .config here: http://pastebin.ca/2006416).

I'll be glad to provide more info or try patches.

Thanks,
-Ben
