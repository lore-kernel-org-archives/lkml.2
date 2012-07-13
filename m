Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2GMOmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:42:54 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:58593 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2GMOmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:42:53 -0400
Message-ID: <1342190571.6607.36.camel@blech>
Subject: Re: UIO: missing resource mapping
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Date: Fri, 13 Jul 2012 16:42:51 +0200
In-Reply-To: <20120713132223.GA10959@redhat.com>
References: <4FFE7C1F.7080702@gmx.net> <20120712194432.GA2592@local>
	 <20120712231632.GC9317@redhat.com> <1342166955.6607.5.camel@blech>
	 <20120713132223.GA10959@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 13.07.2012, 16:22 +0300 schrieb Michael S. Tsirkin:
> Could you give an example of the problem? How do you bind
> both UIO and another driver to the same device? 

Sorry, I'm looking on it from the user-space perspective. Maybe I'm
wrong, but I can give you an example :

lspci -v
...
03:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n
(rev 02)
	Subsystem: Apple Inc. AirPort Extreme
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at b0600000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [d0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Virtual Channel
	Capabilities: [160] Device Serial Number 85-f2-6d-ff-ff-42-68-a8
	Capabilities: [16c] Power Budgeting <?>
	Kernel driver in use: bcma-pci-bridge
...

This Device has one 64 Bit Bar. When I look at the related sysfs
entry ...


ls /sys/bus/pci/devices/0000:03:00.0
...
--w------- 1 root root 4.0K Jul 13 16:35 reset
-r--r--r-- 1 root root 4.0K Jul 12 21:43 resource
-rw------- 1 root root  16K Jul 13 16:35 resource0
lrwxrwxrwx 1 root root    0 Jul 12 23:41 subsystem
-> ../../../../bus/pci
...

... I can see that it should be possible to map resource0 and directly
write into a BAR which is already managed by a kernel drivers. 

Moving this functionality to UIO would only generate those resource
files, if the device is handled by UIO and therefore intended to be
managed from the user-space. 

-- 
Gruß
  Dominic

