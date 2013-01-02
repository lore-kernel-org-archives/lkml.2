Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3ABW2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:28:02 -0500
Received: from magic.merlins.org ([209.81.13.136]:54366 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3ABW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:28:00 -0500
Date: Wed, 2 Jan 2013 14:27:57 -0800
From: Marc MERLIN <marc@merlins.org>
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Fairly reproduceable crash in 3.7.1 Null pointer rb_erase+0xc4/0x292
Message-ID: <20130102222757.GC8631@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.6.6-amd64-preempt-20120903/Debian
 wheezy/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-No-Run: Yes
X-SA-Exim-Connect-IP: 82.235.219.215
X-SA-Exim-Mail-From: merlin@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Google only shows hits pointing to an ext4 patch that didn't go in 3.7
proper.

http://marc.merlins.org/tmp/crash.jpg

My call trace doesn't look copmlete, but shows "fatal exception in interrupt" and:
timerqueue_del
__remove_hrtimer
__run_htrimer
hrtimer_interruypt
smp_apic_timer_interrupt
<???>
paravirt_read_tpe
intel_idle
intel_idle
cpuidle_enter

I had pretty repeated crashes when plugging power back into my running
laptop, but the display just freezes and I can't get a dump.

For the crash here, I did: suspend to RAM, plug power back in, wake up.
Laptop crashed about 3 seconds after wakeup.

I'm on vacation with no hardware to get a proper crash dump or even
serial console, but I have a bad screenshot.

Boy do I wish this could be saved in some kind of NVRAM instead like on
android.


Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
