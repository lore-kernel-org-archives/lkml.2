Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab2EASr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:47:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52991 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2EASru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:47:50 -0400
Date: Tue, 1 May 2012 13:47:34 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Adrian Fita <adrian.fita@gmail.com>, Ralf Jung <ralfjung-e@gmx.de>,
        Paolo Scarabelli <paolo@msw.it>
Subject: [bug?] Battery notifications produce flashing battery icon, syslog
 spam (Re: [PATCH 11/11] ACPI / Battery: Update information on info
 notification and resume)
Message-ID: <20120501184534.GA31731@burratino>
References: <201101062331.17079.rjw@sisk.pl>
 <201101062342.28168.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101062342.28168.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael et al,

Rafael J. Wysocki wrote:

> A notification event 0x81 from an ACPI battery device requires us to
> re-read the battery information structure.  Follow this requirement
> and remove and re-create the battery's attibutes in sysfs so that
> they reflect the reporting units used by the battery at the moment
> (those units may actually change sometimes at run time, which happens
> on some Thinkpads).

Ralf Jung was noticing his system tray power management icon in the
bottom-right corner *flickering* every 30 seconds with recent kernels.
Bisects to v2.6.38-rc1~68^2~4 ("ACPI / Battery: Update information on
info notification and resume"), which has the above description.

Some affected systems:

 HP ProBook 4515s/3077, BIOS 68GPI Ver. F.03 (Adrian Fita)
 HP ProBook 4510s (Paolo Scarabelli)
 HP Compaq 615 (Ralf Jung)

Some symptoms:

 KDE power management icon shows "no battery" for a fraction of a
 second (upower is its backend)

 upowerd makes CPU run at close to 100% CPU all the time (?)

 /var/log/syslog gets lots of messages from laptop-mode, like this:

| Apr 20 10:52:14 zero laptop-mode: Laptop mode
| Apr 20 10:52:14 zero laptop-mode: enabled,
| Apr 20 10:52:14 zero laptop-mode: not active [unchanged]
| Apr 20 10:52:14 zero laptop-mode: Laptop mode
| Apr 20 10:52:14 zero laptop-mode: enabled,
| Apr 20 10:52:14 zero laptop-mode: not active [unchanged]
| Apr 20 10:52:33 zero laptop-mode: Laptop mode
| Apr 20 10:52:33 zero laptop-mode: enabled,

Known problems?  Is there some way to handle notification events
without these side effects?  Anything the submitters can do to help
track details down?

An acpidump from Adrian's system can be found at [1].  More background
at [2].

Thanks,
Jonathan

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=54;filename=acpidump_HP_ProBook_4515s.dat.gz;att=1;bug=670958
[2] http://bugs.debian.org/670958
