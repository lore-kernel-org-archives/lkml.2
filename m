Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab2BQWy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:54:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44212 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab2BQWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:54:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keith.chew@gmail.com designates 10.236.72.170 as permitted sender) smtp.mail=keith.chew@gmail.com; dkim=pass header.i=keith.chew@gmail.com
MIME-Version: 1.0
Date: Sat, 18 Feb 2012 11:54:25 +1300
Message-ID: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
Subject: Hang on "echo b > /proc/sysrq-trigger"
From: Keith Chew <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

To test the reliability of a hardware, I have a script which reboots a
machine every 15 minutes after boot up. This machine has a dual video
output, VGA and DVI-D, both driven via an intel GM45 chipset (I am
using kernel 2.6.39.24 kernel intel drivers).

Some interesting results (which can be reproduced consistently):
"echo b > /proc/sysrq-trigger" via DVI-D - after 2-3 days, it hangs
(freezes) before reboot (dmesg only shows "Resetting...", nothing
after that, no panic, stack trace, etc)
"echo b > /proc/sysrq-trigger" via VGA - runs > 1 week
"reboot -fn" via VGA or DVI-D - runs > 1 week
"reboot" via VGA or DVI-D - runs > 1 week

I suspect that the intel graphics driver is not happy with the "echo b
> /proc/sysrq-trigger" when it is still running.

I would like to make the "echo b" successfully reboot the machine, but
this would appear to be a hardware bug? Is there anything that can be
done in the kernel to make the "echo b" successfully work 100%?

Regards
Keith
