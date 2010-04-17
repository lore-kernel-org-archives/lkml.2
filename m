Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0DQPS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 11:18:59 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1210 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab0DQPS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 11:18:58 -0400
To: linux-kernel@vger.kernel.org
Subject: [regression,bisected] Missing boot messages with VESAFB after VT initialization
Cc: Dave Airlie <airlied@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Content-Disposition: inline
From: Frans Pop <elendil@planet.nl>
Date: Sat, 17 Apr 2010 17:18:55 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004171718.55867.elendil@planet.nl>
X-OriginalArrivalTime: 17 Apr 2010 15:18:56.0157 (UTC) FILETIME=[4BED64D0:01CADE41]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initially all messages from init scripts are displayed correctly, but after
the init script to set up the VT1-VT6 is run, messages from init scripts
are no longer displayed. Instead the display is blank with only a cursor.

However, if I switch back to VT1 from X.Org after the boot has completed,
the missing messages are visible.

System is x86_64 running Debian stable ("Lenny"). I'm using VESAFB (vga=791)
and no KMS.

I've bisected this to the following commit:
   commit 477346ff74f4c2aed50e8a0db96a61069f3e5b80
   Author: Dave Airlie <airlied@redhat.com>
   Date:   Thu Jan 7 17:04:54 2010 +1000
       x86-64: Allow fbdev primary video code

Kernel config is available in: http://lkml.org/lkml/2010/4/16/230

Relevant part of the boot log (I boot with 'quiet'):
[...]
Sat Apr 17 16:52:07 2010: Starting portmap daemon...Already running..
Sat Apr 17 16:52:07 2010: Starting NFS common utilities: statd idmapd.
Sat Apr 17 16:52:08 2010: Setting sensors limits.
Sat Apr 17 16:52:08 2010: Setting console screen modes and fonts.
[Messages after this point are not displayed]
Sat Apr 17 16:52:08 2010: Setting up ALSA...done.
Sat Apr 17 16:52:09 2010: INIT: Entering runlevel: 2
Sat Apr 17 16:52:09 2010: Loading cpufreq kernel modules...done (acpi-cpufreq).
Sat Apr 17 16:52:10 2010: Starting system log daemon....
Sat Apr 17 16:52:10 2010: Starting kernel log daemon....
Sat Apr 17 16:52:10 2010: Starting ACPI services....
Sat Apr 17 16:52:10 2010: Starting system message bus: dbus.
Sat Apr 17 16:52:11 2010: Starting OpenBSD Secure Shell server: sshd.
Sat Apr 17 16:52:11 2010: CPUFreq Utilities: Setting ondemand CPUFreq governor...CPU0...CPU1...done.
Sat Apr 17 16:52:11 2010: Starting HTTP server: boa.
Sat Apr 17 16:52:11 2010: Starting Common Unix Printing System: cupsd.
Sat Apr 17 16:52:13 2010: Starting DirMngr: dirmngr.
Sat Apr 17 16:52:13 2010: Starting MTA: exim4.
Sat Apr 17 16:52:14 2010: Starting LAN Information Server: lisa.
Sat Apr 17 16:52:14 2010: Setting up Machine Check Exceptions trigger... done.
Sat Apr 17 16:52:14 2010: Running Machine Check Exceptions decoder... done.
Sat Apr 17 16:52:14 2010: Starting NFS common utilities: statd idmapd.
Sat Apr 17 16:52:14 2010: Not starting internet superserver: no services enabled.
Sat Apr 17 16:52:14 2010: Setting sysfs variables....
Sat Apr 17 16:52:15 2010: Starting file alteration monitor: FAM.
Sat Apr 17 16:52:15 2010: Starting Hardware abstraction layer: hald.
Sat Apr 17 16:52:17 2010: Starting bluetooth: disabled. see /etc/default/bluetooth.
Sat Apr 17 16:52:17 2010: Starting /usr/sbin/chronyd...
Sat Apr 17 16:52:18 2010: chronyd is running and online.
Sat Apr 17 16:52:18 2010: Starting anac(h)ronistic cron: anacron.
Sat Apr 17 16:52:18 2010: Starting deferred execution scheduler: atd.
Sat Apr 17 16:52:19 2010: Starting periodic command scheduler: crond.
Sat Apr 17 16:52:19 2010: Starting K Display Manager: kdm.

The "Setting console screen modes and fonts" message comes from the init
script /etc/rcS.d/S48console-screen.sh. When that script is run the 2 tux
logos for my 2 CPU cores also disappear.

Cheers,
FJP
