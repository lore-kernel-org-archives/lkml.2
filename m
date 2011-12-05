Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab1LETzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:55:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58183 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab1LETzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:55:47 -0500
MIME-Version: 1.0
Date: Mon, 5 Dec 2011 11:55:45 -0800
Message-ID: <CAK3+h2zaZ3J4F4_rx6LGM0f_iY7ao8rU9nCt3EpZXDRGrqm3hQ@mail.gmail.com>
Subject: Seeking Linux watchdog design advice to trouble shoot mystory silent
 reboot issue
From: Vincent Li <vincent.mc.li@gmail.com>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we have  a complex system with a large number of processes running
simutanously. If any of the processes gets into a faulty state and
hangs or consumes more than its fair share of the system resources,
the other processes may not get a chance to run, and the whole system
can hang, interrupting the system functionality and user traffic.

In order to prevent the system from hanging, We uses a host watchdog
mechanism to make sure the system can detect and get out of a hanging
state with a host reboot. This feature is implemented with the
hardware watchdog counter. The counter is initialized to a fixed
number, and counts down automatically unless it is reset by a special
user space software process, say watchdog. When watchdog gets a chance
to run, it touches the hardware watchdog counter. If the system gets
too busy, and the watchdog process does not get a chance to run before
the hardware watchdog counter reaches 0, the host is rebooted in an
attempt to recover from the hanging system.

Recently, there have been a number of cases in which the  units
silently rebooted without much information logged in the system log.
In most silent reboot cases, the unit was rebooted because of a host
hardware watchdog reboot, and because of the nature of the host
watchdog reboots, not much information about the current states of the
system is preseved or logged before the hardware reboot takes effect.
After the reboot, it is hard to analyze the real cause of the system
being hang.

we have been thinking moving the user space watchdog process to kernel
and invoke some kernel  function like dump_stack to show the hanging
process stack trace before hardware reset. we have tried
drivers/watchdog/softdog.c as prove of this idea, but  we are unable
to get the hanging process stack trace. we also tried to use kdump in
kernel, but we are unable to run kdump  in  kernel for some other
technical reason.

CPU and memory control group features are not considered at this stage
because it is too invasive to change in our custom kernel.

could you share  your experience on this kind of issue, we really
would like to be able to find out which faulty process caused the CPU
to deschedue user space watchdog process and dump the stack trace of
that faulty process.

Thank you in advance!

Vincent
