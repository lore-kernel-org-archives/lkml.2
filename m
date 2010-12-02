Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0LBSRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:17:25 -0500
Received: from anvil.nuitari.net ([67.205.71.108]:45254 "EHLO
	anvil.nuitari.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab0LBSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:17:24 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Dec 2010 13:17:24 EST
Date: Thu, 2 Dec 2010 13:18:36 -0500 (EST)
From: Stephane Bakhos <nuitari@nuitari.net>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Infinite listens for haproxy in /proc/net/tcp
Message-ID: <Pine.LNX.4.64.1012021313080.25944@anvil.nuitari.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happens whether the file is read directly, or using netstat.
It looks like haproxy has millions of LISTEN.

We've tried to see if there is a definitive count, but after 20 minutes of 
running cat /proc/net/tcp we gave up. This is an intermittent problem.

According to ss, there is about 5500 connections running on the system.

ss -t -l -p outputs the correct information.


scripts/ver_linux:
Linux 2.6.36 #3 SMP Tue Nov 16 22:59:17 CET 2010 x86_64 GNU/Linux

Gnu C                  4.3.2
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.41.3
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
Modules Loaded         tcp_diag inet_diag ipt_REJECT xt_tcpudp 
iptable_filter ip_tables x_tables binfmt_misc loop usbhid hid option 
usb_wwan usbserial psmouse evdev pcspkr serio_raw tpm_tis tpm tpm_bios 
ehci_hcd ohci_hcd shpchp pci_hotplug i2c_nforce2 i2c_core processor 
thermal button thermal_sys dcdbas
