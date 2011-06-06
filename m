Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab1FFWCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:02:49 -0400
Received: from lucidpixels.com ([75.144.35.66]:42137 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab1FFWCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:02:48 -0400
Date: Mon, 6 Jun 2011 18:02:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Brad Campbell <lists2009@fnarfbargle.com>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.39 kernel panic w/screenshots & kernel cfg link provided
In-Reply-To: <alpine.DEB.2.02.1106051601230.3462@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1106061800480.3462@p34.internal.lan>
References: <alpine.DEB.2.02.1105280755050.4345@p34.internal.lan> <4DE4FBB0.9080708@fnarfbargle.com> <alpine.DEB.2.02.1106051601230.3462@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Jun 2011, Justin Piszcz wrote:

>
>
> On Tue, 31 May 2011, Brad Campbell wrote:
>
>> On 28/05/11 20:01, Justin Piszcz wrote:
>>> Hello,
>
> Hi,
>
> This was happening on a regular basis, since then I have performed the
> following: (sdc,sdd,sde were recently added)
>
> # hal-disable-polling --device /dev/sr0
> Polling is already disabled on the given drive.
> # hal-disable-polling --device /dev/sdd
> Polling for drive /dev/sdd have been disabled. The fdi file written was
> # hal-disable-polling --device /dev/sde
> Polling for drive /dev/sde have been disabled. The fdi file written was
> # hal-disable-polling --device /dev/sdc
> Polling for drive /dev/sdc have been disabled. The fdi file written was
>
> # ps auxww|grep udisks
> root      4125  0.0  0.0 127464  5844 ?        Sl   07:54   0:00 
> /usr/lib/udisks/udisks-daemon
> root      4126  0.0  0.0  45088  1100 ?        S    07:54   0:00 
> udisks-daemon: polling /dev/sr0 /dev/sdd /dev/sde /dev/sdc
> root     13335  0.0  0.0   8648   844 pts/8    S+   08:23   0:00 grep udisks
> # dpkg -S /usr/lib/udisks/udisks-daemon
> udisks: /usr/lib/udisks/udisks-daemon
> # apt-get remove udisks
>
> # uname -a
> Linux box 2.6.39 #11 SMP Tue May 31 15:51:52 EDT 2011 x86_64 GNU/Linux
>
> So far, my system has not crashed in 4 days after doing this, I am also using 
> the 'threadirqs' boot option, if it crashes again I'll provide an update
> but so far it has been stable..
>
> Justin.
>

For others who also have crashes, do your crashes persist when you disable 
these options (don't use ACPI) for ATA/SATA.

CONFIG_ATA_ACPI=y
CONFIG_PATA_ACPI=m

Recently I added a lot of options to my .config (compiled them as 
modules), I noticed two items, one, when all of the ATA devices (SATA), 
not the deprecated ones and/or the ACPI option for libata, that seemed to 
be the final culprit that may have been causing my issues, no crashes.. 
yet.

Justin.

