Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2GIGXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:23:46 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:54998 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2GIGXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:23:45 -0400
Message-Id: <4FFA950B020000A10000A68F@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 09 Jul 2012 08:23:39 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: "Ryan Mallon" <rmallon@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Antw: Re: /sys and access(2): Correctly implemented?
References: <4FF6A17B020000A10000A5E8@gwsmtp1.uni-regensburg.de>
 <4FFA16B6.9050009@gmail.com>
In-Reply-To: <4FFA16B6.9050009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ryan Mallon <rmallon@gmail.com> schrieb am 09.07.2012 um 01:24 in Nachricht
<4FFA16B6.9050009@gmail.com>:
> On 06/07/12 16:27, Ulrich Windl wrote:
> > Hi!
> > 
> > Recently I found a problem with the command (kernel 3.0.34-0.7-default from 
> SLES 11 SP2, run as root):
> > test -r "$file" && cat "$file"
> > emitting "Permission denied"
> > 
> > Investigating, I found that "test" actually uses "access()" to check for 
> permissions. Unfortunately there are some files in /sys that have "write-only" 
> permission bits set (e.g. /sys/devices/system/cpu/probe).
> > 
> > ~ # ll /sys/devices/system/cpu/probe
> > --w------- 1 root root 4096 Jun 29 12:43 /sys/devices/system/cpu/probe
> > ~ # F=/sys/devices/system/cpu/probe
> > ~ # test "$F" && cat "$F"
> > cat: /sys/devices/system/cpu/probe: Permission denied
> 
> Looks like you have a typo here, I think you wanted "test -r $F", not
> "test $F", the latter will just evaluate "$F" as an expression which
> will be true, and so you get the permission denied error running cat.

Hi!

You are right: It's a typo, but only in the message; the actual test was done correctly, and the outcome is quite the same.

> 
> Using "test -r $F" on a write-only sysfs file correctly returns false on
> my machine (Ubuntu 10.04.4 LTS/2.6.32-41-generic).

Not here, unfortunately:
# ll /sys/devices/system/cpu/probe
--w------- 1 root root 4096 Jul  2 11:52 /sys/devices/system/cpu/probe
# F=/sys/devices/system/cpu/probe
# test -r "$F" && cat "$F"
cat: /sys/devices/system/cpu/probe: Permission denied
# uname -a
Linux h07 2.6.32.59-0.3-default #1 SMP 2012-04-27 11:14:44 +0200 x86_64 x86_64 x86_64 GNU/Linux

Regards,
Ulrich


