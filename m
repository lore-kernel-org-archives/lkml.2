Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1CHNtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:49:53 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:43418 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1CHNtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:49:52 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-lvm@redhat.com
Subject: Re: 2.6.37.2: LVM pvmove hangs system
Date: Tue, 8 Mar 2011 14:49:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-0.6-desktop; KDE/4.5.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201103081038.38338.eike-kernel@sf-tec.de>
In-Reply-To: <201103081038.38338.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201103081449.44783.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 08 März 2011, 10:38:38 schrieb Rolf Eike Beer:
> Hi all,
> 
> I'm experiencing a very annoying system lockup for some days. The setup is
> as follows:
> 
> -two pairs of SATA disks that are bundled into a software raid 1 each
> -each of the raid devices is a physical volume
> -a volume group that includes both pv's
> -all mounted volumes (including root and swap) are in that vg
> 
> The machine is a Xeon E5520 with 16G RAM that is otherwise idle, so swap
> shouldn't matter. And from what I read out of the documentation this all
> looks perfectly sane, but:
> 
> Now I try to move the data from one pv to the other using pv. This prints
> out the current state (currently 10.9%) and then starts doing something.
> Two minutes later the kernel will complain:

After some further testing I _think_ I have an idea what's going on: this is a 
deadlock somewhere in the I/O stack. I have recompiled the kernel with all the 
lock debugging enabled and will probably test this but this is a production 
machine that should better get online again better sooner than later so my 
amount of what I can test is pretty limited. Since the machine is currently 
doing the move and actually working I have not yet booted into the debug 
kernel.

What I did was basically stopping everything on the machine. The only 
userspace programs currently running are init, my sshd, my screen, shell, and 
of course pvmove. And now it works. Whenever I try to do anything that causes 
I/O in parallel the machine will stop working. So this box is basically at 
runlevel 1 now moving all the stuff around instead of doing some useful work 
while moving in the background :(

Eike
