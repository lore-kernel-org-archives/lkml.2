Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422788Ab2KNMmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:42:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36909 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422749Ab2KNMmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:42:38 -0500
MIME-Version: 1.0
Date: Wed, 14 Nov 2012 13:42:37 +0100
Message-ID: <CAN5d0gJVrf7OtTNOoJa_9LMy_RuR97OAWcSwMD8x22dNRfEY-g@mail.gmail.com>
Subject: RTC-CMOS ALARM fields always resetted on reboot on x86
From: Andy Hirsh <andhirsh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I'm having a strange behaviour with the RTC upgrading from kernel
2.6.32/2.6.34 to 2.6.38.8 on x86:

the rtc_cmos alarm time&date fields are always set to 00:00:00
1970-01-01 after the boot process...

eg:

cat /proc/driver/rtc  before reboot:

rtc_time        : 12:07:11
rtc_date        : 2012-11-14
alrm_time       : 09:01:20
alrm_date       : 2012-11-15
alarm_IRQ       : no
alrm_pending    : no
24hr            : yes
periodic_IRQ    : no
update_IRQ      : no
HPET_emulated   : yes
BCD             : yes
DST_enable      : no
periodic_freq   : 1024
batt_status     : okay

after reboot:

rtc_time        : 12:15:39
rtc_date        : 2012-11-14
alrm_time       : 00:00:00
alrm_date       : 1970-01-01
alarm_IRQ       : no
alrm_pending    : no
24hr            : yes
periodic_IRQ    : no
update_IRQ      : no
HPET_emulated   : yes
BCD             : yes
DST_enable      : no
periodic_freq   : 1024
batt_status     : okay

during the boot process, the kernel reports:

...
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
...

with kernels 2.6.32.5 or 2.6.34.5 there are no problems... alarms
date&time values are not resetted.

     thanks a lot for any ideas...

             andy
