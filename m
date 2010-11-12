Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab0KLTP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:15:58 -0500
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:43365 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932443Ab0KLTP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:15:56 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 82CC4107B7E
Subject: HID: questions about polling rates
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 20:15:52 +0100
Message-ID: <1289589352.2629.95.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

while working on my roccat device drivers I thought about the possiblity
of on the fly polling rate changes and tested some things.

First I tried different polling rates by writing values from 1 to 10
into /sys/bus/usb/drivers/usbhid/module/parameters/mousepoll. I observed
that the polling rates seem to be capped on both sides. With value 1 I
measure 2ms instead of 1ms with my hardware protocol analyzer. With 10 I
get 8ms instead of 10ms.
I only use cheap onboard usb controllers, but under windows they work
with 1ms.
A internet and code search revealed nothing regarding this to me. Is
someone of you aware of this behaviour and could tell me more about it?

Changing the polling rate of a device on the fly would requires to use
usb_kill_urb() and usb_submit_urb() with new interval. To get the
int_urb I would need additional informations for incomplete struct
usbhid_device that lie in drivers/hid/usbhid/usbhid.h.
My driver code is at home in drivers/hid/. Is it okay to include a
header further down in the structure? Or does anyone have concerns about
moving the mentioned header to include/linux? Is this a matter to follow
at all?

Thanks in advance
Stefan

