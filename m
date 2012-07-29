Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2G2OMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 10:12:09 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:33593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab2G2OMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 10:12:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/6] PM: Suspend/resume for clock sources/clock event devices in PM domains
Date: Sun, 29 Jul 2012 16:12:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207291612.43138.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There is a problem with clock sources and clock event devices belonging to PM
domains that they have to be marked as "always on", to prevent those domains
from being turned off unexpectedly, which also prevents the domains from
being turned off during system suspend, although that might be done and would
be desirable.

The following patch series introduces a mechanism by which the generic PM
domains framework can be notified that a given domain may be turned off
after timekeeping has been suspended, which allows the domains that contain
clock sources and clock event devices to be turned off before the system
enters the target sleep state (so that less power is used in that state).

[1/6] Introduce simplified power on routine for PM domains (to be used during
      system resume from suspend/hibernation and during "syscore" resume).
[2/6] Introduce function for notifying the generic PM domains framework that
      the given device may be treated as suspended (so its domain may be
      turned off if this has been the last active device in it).
[3/6] Introduce suspend/resume callbacks for clock event devices.
[4/6] Make the SH TMU driver use suspend/resume callbacks for clock sources
      and clock event devices to notify the generic PM domains framework that
      those devices may be regarded as suspended (during system suspend) or
      that they have to be turned on immediately (during system resume).
[5/6] Like [4/6] but for the SH CMT driver.
[6/6] Analogous to [4/6], but for the SH MTU2 driver.

The patchset has been tested on the SH7372 Mackerel board.

Thanks,
Rafael
