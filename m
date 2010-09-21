Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0IUVzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:55:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63983 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0IUVzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:55:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Y/b5DwcD1GT/ST4hdXTwkZeFRdiyjrlrv3AUsQx4K46InW8QuVdyfAC9l2KyLCz7QN
         rYqBN0yvq7BMaLOuIycQmSf8QXeTOQUOQSOI4pKWybDuwXG/kuGDN8L2znxn83xUhUNY
         Mb8gyw7SKk5Ds0IGJgTWMqbfMLXBeeqpQr3p0=
MIME-Version: 1.0
Date: Wed, 22 Sep 2010 09:55:04 +1200
Message-ID: <AANLkTim9Sz6o46Rxs=YX0=+5FwmrCr0=rtrOvLXJAH91@mail.gmail.com>
Subject: HDMI/DVI unplug/plug kernel uevent
From: Keith Chew <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

First, I apologise if this is not the correct mailing list to post my
question, it relates to both the kernel source and Xorg server. I will
re-post this to the Xorg mailing list if I cannot get an answer here.

I have a linux box which is connected to only one type of LCD. Using
Fedora 13, I am on:
- Xorg server 1.8.2
- kernel 2.6.33.2
- fluxbox with all services turned off (except crond, network), ie no
other userspace daemons

My problem is when I unplug and plug in the HDMI, I can see
/var/log/Xorg.0.log reprobing the LCD, and sometimes the screen goes
blank. I would like to disable this probe on the even of unplug/plug.

In drivers/gpu/drm/i915/i915_irq.c, there is this line:
-------------------
	/* Just fire off a uevent and let userspace tell us what to do */
	drm_sysfs_hotplug_event(dev);
-------------------

If I uncomment drm_sysfs_hotplug_event(), the uvent is not fired
(verified from udevadm --monitor) and no re-probing is done, perfect.
However, my real goal is to change the userspace app that is consuming
this uevent and not call the probe method. But I can't seem to find
out which app is consuming the uevent. I looked at the Xorg server's
sourcecode but cannot find see anykind of listener for this uevent (or
even a polling routine to check the drm sysfs status).

Can someone point me to the right direction please?

Regards
Keith
