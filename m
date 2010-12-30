Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0L3H6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 02:58:49 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39424 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0L3H6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 02:58:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YZ9tbwuF0CY9CzX1oaUTqHfAG0eFcmo06qUgGvvymEChEQqP5l22wIu4mlKbpOZ5CY
         5oRj8SuOdmN9ccdJ3LDMvnN98YOOHDNzG1rEux+fvmT8zmzhTE7mhIqblUFkksB/MyED
         KfXWe88KXYBaD+GsflzoOrurrLul6GgznUoXs=
Subject: Re: Why do programs freeze with big network transfers?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <ifhc54$efg$1@dough.gmane.org>
References: <ifhc54$efg$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Dec 2010 08:58:39 +0100
Message-ID: <1293695919.7150.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 décembre 2010 à 17:25 +1000, Adam Nielsen a écrit :
> Hi all,
> 
> I'm a bit stuck on this problem so I hope someone can help.  My desktop PC is 
> running kernel 2.6.33.1 and when I copy some largish files (2-3GB each) onto 
> an NFS share my PC becomes unusable, pretty much locking up for 60 seconds at 
> a time.
> 
> Everything works fine for a little while once the copy has begun - the files 
> are read off the software-RAID-0 disks at about 200MB/sec, then after 10 
> seconds or so data starts going across the gigabit network at about 40MB/sec 
> (speed limited by the target system which pegs at 100% CPU due to lack of 
> jumbo packets.)
> 
> After a few seconds of data going over the network, X-Windows freezes.  No 
> screen updates, the mouse cursor won't move, for all intents and purposes the 
> system has frozen solid.  I'm playing music with XMMS2 and that keeps going, 
> but occasionally even that stops too.  After a minute (between 45 and 65 
> seconds) everything unfreezes and keeps going as per normal.  Less than 10 
> seconds later everything freezes again for another minute!  This keeps going 
> until the file transfer has finished.
> 
> When things unfreeze the disk is idle, and within 10 seconds the disk starts 
> up again and almost immediately the next minute-long freeze begins.  While 
> things are frozen the network transfer continues, and bizarrely I can log in 
> to the machine over SSH where everything seems normal.  'top' reports most 
> processes are idle, and running a command line XMMS2 client happily reports 
> that the song I am listening to is stuck at exactly the same point until the 
> freeze is over, when the seconds start counting up again.
> 
> The reason I am stuck is that nothing is appearing in dmesg, so it appears the 
> kernel is unaware of the problem.  Has anyone seen anything like this before? 
>   I'm not sure what to do next.
> 
> Disks are connected to an Intel ICH9 SATA controller in AHCI mode, LAN is a 
> Realtek 8169, video card is nVidia GeForce 8600.  Perhaps some combination of 
> this is to blame?
> 
> I have tried using cat to read these files into /dev/null and the system will 
> happily read the files at full speed without freezing, and I have used ttcp's 
> speed test function to send data over the network at full speed, which also 
> works without X11 freezing.  Doing this at the same time (reading from the 
> disk and sending network traffic) also works fine without locking up, so it 
> seems the problems only arise when NFS gets involved.
> 
> 'mount' reports the options on the NFS share as:
>    rw,user=adam,tcp,soft,intr,timeo=20,vers=3,addr=192.168.0.6
> 
> Any suggestions about what I can do next?
> 
> Many thanks,
> Adam.

CC netdev

This rings a bell here, could you try to apply commit 

482964e56e1320cb7952faa1932d8ecf59c4bf75
(net: Fix the condition passed to sk_wait_event())

This commit was included in 2.6.36, so you could also try 2.6.36.2
kernel.

http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=482964e56e1320cb7952faa1932d8ecf59c4bf75

Thanks


