Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2ITTIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:08:06 -0400
Received: from fbsmtp.dnsalias.org ([82.66.248.156]:59449 "EHLO
	fbsmtp.dnsalias.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2ITTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:08:04 -0400
X-Greylist: delayed 1521 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2012 15:08:04 EDT
Date: Thu, 20 Sep 2012 20:42:34 +0200
From: =?ISO-8859-1?Q?Fran=E7ois?= Boisson 
	<user.anti-spam@maison.homelinux.net>
To: linux-kernel@vger.kernel.org
Subject: shutdown with toshiba portege
Message-Id: <20120920204234.0fb035a89f88a2e1f468aa54@maison.homelinux.net>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Scanner: exiscan *1TElhr-0005Ty-00*XfKKF9rsLmI*
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey 

I have a problem which seems to be related to shutdown for a Toshiba portege
(it's seems that the problem is also on other Toshiba, on VAIO cw5, you can
look at this thread on debian-user-french
http://lists.debian.org/debian-user-french/2012/08/msg00164.html
)


Symptoms (under 3.0, 3.1, 3.2, 3.3 and 3.5.2 and 3.5.4 amd64 kernels but not
with 2.6.37-486-PAE kernel) under a 
TOSHIBA PORTEGE Z830/Portable PC, BIOS Version 1.60 

If i shutdown the computer and wait some hours, the power consumption of the
computer is not null, it's about the same as the power consumtion during a
suspend of computer. In fact

Boot and halt with:
Windows 7 ---> No power consumption after
Linux 2.6.37-486-PAE --->  No power consumption after
Linux >= 3.0  ---> Power consumption (about 45-50 mW if acpitool is correct)

I try 3.0, 3.1, 3.2.0 (Debian wheezy kernel), 3.3, 3.5.2 and 3.5.4 kernels.
(System is a debian wheezy amd64 with (now) personnal kernel)

First I think it was something like Wake-On-Lan then Wake-on-WLan but I found
nothing (WLAN and WWLAN are disabled or not present)
Then I look on kernel source and I have found this in
arch/x86/kernel/apic/apic.c :

[...]
/*
 * If Linux enabled the LAPIC against the BIOS default disable it down before
 * re-entering the BIOS on shutdown.  Otherwise the BIOS may get confused and
 * not power-off.  Additionally clear all LVT entries before disable_local_APIC
 * for the case where Linux didn't enable the LAPIC.
 */
void lapic_shutdown(void)
{
[...]

I wonder if my problem is the problem describe here or something like. It
seems that computer can be shutdown but some peripherics not power off. So I
try to «trace» the shutdown process but I did not found the description a the
kernel way to shutdown the computer. It seems that it's

* Shutdown all CPUs execpt the CPU0
* Shutdown local APIC
* Shutdown computer
but perhaps the problem is before these opérations.

Where can I verify that all is really power off before shutdown (with
judicious printk for instance)

I try to look in kernel documentation but I did not found.

Thanks for any help or advices and sorry for noise if you think it is.

François Boisson
