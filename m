Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2HEXt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:49:27 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab2HEXs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:48:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/15] PM: Suspend/resume and runtime PM for clock sources/clock event devices in PM domains
Date: Mon, 6 Aug 2012 01:38:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201207291612.43138.rjw@sisk.pl>
In-Reply-To: <201207291612.43138.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208060138.03950.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Sunday, July 29, 2012, Rafael J. Wysocki wrote:
> There is a problem with clock sources and clock event devices belonging to PM
> domains that they have to be marked as "always on", to prevent those domains
> from being turned off unexpectedly, which also prevents the domains from
> being turned off during system suspend, although that might be done and would
> be desirable.
> 
> The following patch series introduces a mechanism by which the generic PM
> domains framework can be notified that a given domain may be turned off
> after timekeeping has been suspended, which allows the domains that contain
> clock sources and clock event devices to be turned off before the system
> enters the target sleep state (so that less power is used in that state).
> 
> [1/6] Introduce simplified power on routine for PM domains (to be used during
>       system resume from suspend/hibernation and during "syscore" resume).
> [2/6] Introduce function for notifying the generic PM domains framework that
>       the given device may be treated as suspended (so its domain may be
>       turned off if this has been the last active device in it).
> [3/6] Introduce suspend/resume callbacks for clock event devices.
> [4/6] Make the SH TMU driver use suspend/resume callbacks for clock sources
>       and clock event devices to notify the generic PM domains framework that
>       those devices may be regarded as suspended (during system suspend) or
>       that they have to be turned on immediately (during system resume).
> [5/6] Like [4/6] but for the SH CMT driver.
> [6/6] Analogous to [4/6], but for the SH MTU2 driver.
> 
> The patchset has been tested on the SH7372 Mackerel board.

There were no comments, so I think I can go a bit further and add runtime PM
support to those drivers too. :-)

This requires some core changes, but they aren't too invasive in my opinion.

Patches [1-6/15] are more-or-less the same as before modulo some fixes for bugs
found during more thorough testing.  The remaining patches make the following
changes:

[7/15] - Clean up device PM initialization.
[8/15] - Allow early platform device drivers to use runtime PM helper functions.
[9/15] - Rename the "always_on" device flag to "syscore".
[10/15] - Move the "syscore" flag to the core (from PM domains framework).
[11/15] - Rework the "starting" of devices flagged as "irq safe" in PM domains.
[12/15] - Add runtime PM support to the SH TMU driver.
[13/15] - Add runtime PM support to the SH CMT driver.
[14/15] - Add runtime PM support to the SH MTU2 driver.
[15/15] - Stop using the "syscore" device flag for runtime PM.

Thanks,
Rafael

