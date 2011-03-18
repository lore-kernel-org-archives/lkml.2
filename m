Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1CRP3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:29:13 -0400
Received: from mail.moocowproductions.org ([50.56.82.78]:57252 "EHLO
	mail.moocowproductions.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756801Ab1CRP3H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:29:07 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 11:29:07 EDT
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Tim Soderstrom <tim@moocowproductions.org>
In-Reply-To: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
Date: Fri, 18 Mar 2011 10:19:05 -0500
Cc: linux-usb@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 18, 2011, at 10:08 AM, Justin Piszcz wrote:

> Hi,
> 
> I can write to just about the entire USB stick, with no errors:
> 
> atom:~# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda2             5.8G  1.5G  4.3G  26% /
> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
> udev                   10M  140K  9.9M   2% /dev
> tmpfs                 2.0G     0  2.0G   0% /dev/shm
> atom:~# cd /
> atom:/# ls
> bin   cdrom  etc   lib    media  nfs  proc  sbin     srv  tmp  var
> boot  dev    home  lib64  mnt    opt  root  selinux  sys  usr
> atom:/# dd if=/dev/zero of=bigfile bs=1M count=4000
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 135.536 s, 30.9 MB/s
> atom:/# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda2             5.8G  5.4G  350M  95% /
> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
> udev                   10M  140K  9.9M   2% /dev
> tmpfs                 2.0G     0  2.0G   0% /dev/shm
> atom:/# rm bigfile
> 
> However, after some amount of time, the errors occur below, is this USB
> stick failing?  Since it has no SMART, is there any other way to verify
> the 'health' of a USB stick?

What prompted you to go with XFS over, say, ext2? The journal will generally cause quite a bit more writes onto your USB device. I use ext2 on my CF card in my NAS for that reason (the spinning media is on XFS of course). I know that's not an answer to your problem but thought I would add it as a suggestion :)

Tim

