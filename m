Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0CTQPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 12:15:23 -0400
Received: from legolas.restena.lu ([158.64.1.34]:45605 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab0CTQPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 12:15:11 -0400
Date: Sat, 20 Mar 2010 17:00:14 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [PATCH v2 0/6] hid: new driver for PicoLCD device
Message-ID: <20100320170014.440959a8@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for PicoLCD USB HID device adding support for
the various features in different patches so each patch concentrates
on a device class.

I implemented the patches so input support is required (this should
make it easy to later on add support for other PicoLCD device that
don't have the same feature set but share compatible HID reports.

This causes presence of a few #ifdef blocks to include support for the
different feature sets when their matching device class has been
selected.
Though to minimize the amount of such #ifs I put all code for a single
class together and defined a few stubs in the #else part so global
device initialization is not filled with #ifs.

I'm not sure which of the following approaches is better (I took the
first one):
- Check for built-in or build-as-module class support
  with #if defined():
  #if defined(CONFIG_..CLASS) || defined(CONFIG_..CLASS_MODULE)
- Add extra CONFIG_PICOLCD_$CLASS to Kconfig and let Kconfig get
  things correctly set having just simple
  #ifdef CONFIG_PICOLCD_$CLASS in the code.


The series depends on my previous patch adding HID suspend support
(I've not yet looked at improving it). The patch adding support
for backlight class depends on backlight state as of 2.6.34-rc2.

All the rest should apply against 2.6.33 (unless I did oversee some
detail).

Bruno
