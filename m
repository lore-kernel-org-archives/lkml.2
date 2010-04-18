Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0DRVNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 17:13:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab0DRVNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 17:13:46 -0400
Subject: Re: [regression,bisected] Missing boot messages with VESAFB after
 VT initialization
From: Dave Airlie <airlied@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
In-Reply-To: <201004171718.55867.elendil@planet.nl>
References: <201004171718.55867.elendil@planet.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 07:10:28 +1000
Message-ID: <1271625028.19111.0.camel@t60prh>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-17 at 17:18 +0200, Frans Pop wrote:
> Initially all messages from init scripts are displayed correctly, but after
> the init script to set up the VT1-VT6 is run, messages from init scripts
> are no longer displayed. Instead the display is blank with only a cursor.
> 
> However, if I switch back to VT1 from X.Org after the boot has completed,
> the missing messages are visible.
> 
> System is x86_64 running Debian stable ("Lenny"). I'm using VESAFB (vga=791)
> and no KMS.
> 
> I've bisected this to the following commit:
>    commit 477346ff74f4c2aed50e8a0db96a61069f3e5b80
>    Author: Dave Airlie <airlied@redhat.com>
>    Date:   Thu Jan 7 17:04:54 2010 +1000
>        x86-64: Allow fbdev primary video code

Can you diff dmesg with/without this?

It shouldn't do anything unless you have multiple framebuffer drivers.

Dave.

> 
> Kernel config is available in: http://lkml.org/lkml/2010/4/16/230
> 
> Relevant part of the boot log (I boot with 'quiet'):
> [...]
> Sat Apr 17 16:52:07 2010: Starting portmap daemon...Already running..
> Sat Apr 17 16:52:07 2010: Starting NFS common utilities: statd idmapd.
> Sat Apr 17 16:52:08 2010: Setting sensors limits.
> Sat Apr 17 16:52:08 2010: Setting console screen modes and fonts.
> [Messages after this point are not displayed]
> Sat Apr 17 16:52:08 2010: Setting up ALSA...done.
> Sat Apr 17 16:52:09 2010: INIT: Entering runlevel: 2
> Sat Apr 17 16:52:09 2010: Loading cpufreq kernel modules...done (acpi-cpufreq).
> Sat Apr 17 16:52:10 2010: Starting system log daemon....
> Sat Apr 17 16:52:10 2010: Starting kernel log daemon....
> Sat Apr 17 16:52:10 2010: Starting ACPI services....
> Sat Apr 17 16:52:10 2010: Starting system message bus: dbus.
> Sat Apr 17 16:52:11 2010: Starting OpenBSD Secure Shell server: sshd.
> Sat Apr 17 16:52:11 2010: CPUFreq Utilities: Setting ondemand CPUFreq governor...CPU0...CPU1...done.
> Sat Apr 17 16:52:11 2010: Starting HTTP server: boa.
> Sat Apr 17 16:52:11 2010: Starting Common Unix Printing System: cupsd.
> Sat Apr 17 16:52:13 2010: Starting DirMngr: dirmngr.
> Sat Apr 17 16:52:13 2010: Starting MTA: exim4.
> Sat Apr 17 16:52:14 2010: Starting LAN Information Server: lisa.
> Sat Apr 17 16:52:14 2010: Setting up Machine Check Exceptions trigger... done.
> Sat Apr 17 16:52:14 2010: Running Machine Check Exceptions decoder... done.
> Sat Apr 17 16:52:14 2010: Starting NFS common utilities: statd idmapd.
> Sat Apr 17 16:52:14 2010: Not starting internet superserver: no services enabled.
> Sat Apr 17 16:52:14 2010: Setting sysfs variables....
> Sat Apr 17 16:52:15 2010: Starting file alteration monitor: FAM.
> Sat Apr 17 16:52:15 2010: Starting Hardware abstraction layer: hald.
> Sat Apr 17 16:52:17 2010: Starting bluetooth: disabled. see /etc/default/bluetooth.
> Sat Apr 17 16:52:17 2010: Starting /usr/sbin/chronyd...
> Sat Apr 17 16:52:18 2010: chronyd is running and online.
> Sat Apr 17 16:52:18 2010: Starting anac(h)ronistic cron: anacron.
> Sat Apr 17 16:52:18 2010: Starting deferred execution scheduler: atd.
> Sat Apr 17 16:52:19 2010: Starting periodic command scheduler: crond.
> Sat Apr 17 16:52:19 2010: Starting K Display Manager: kdm.
> 
> The "Setting console screen modes and fonts" message comes from the init
> script /etc/rcS.d/S48console-screen.sh. When that script is run the 2 tux
> logos for my 2 CPU cores also disappear.
> 
> Cheers,
> FJP


