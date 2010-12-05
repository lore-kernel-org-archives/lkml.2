Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0LEOnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 09:43:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54730 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab0LEOnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 09:43:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [Regression] firewire_ohci causes system resume to fail
Date: Sun, 5 Dec 2010 15:42:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012051542.31826.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a regression I can reproduce 100% of the time on a AMD-based desktop
box that resume from hibernation (or suspend) fails because of the firewire_ohci
module.  The box just hangs when firewire_ohci resume runs, apparently, and it
is sufficient to do:

# echo devices > /sys/power/pm_test
# echo disk > /sys/power/state

to reproduce the issue.

It definitely works with 2.6.34, but it fails with 2.6.37-rc4+ (latest mainline).
I haven't tested the kernels in between, but I'm going to do that later today
or some time next week.

If you have any idea about what may be the reason, please let me know.

Thanks,
Rafael
