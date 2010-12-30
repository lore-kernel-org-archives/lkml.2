Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab0L3HaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 02:30:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:34010 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab0L3HaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 02:30:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Why do programs freeze with big network transfers?
Date: Thu, 30 Dec 2010 17:25:22 +1000
Message-ID: <ifhc54$efg$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 124-148-56-44.dyn.iinet.net.au
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm a bit stuck on this problem so I hope someone can help.  My desktop PC is 
running kernel 2.6.33.1 and when I copy some largish files (2-3GB each) onto 
an NFS share my PC becomes unusable, pretty much locking up for 60 seconds at 
a time.

Everything works fine for a little while once the copy has begun - the files 
are read off the software-RAID-0 disks at about 200MB/sec, then after 10 
seconds or so data starts going across the gigabit network at about 40MB/sec 
(speed limited by the target system which pegs at 100% CPU due to lack of 
jumbo packets.)

After a few seconds of data going over the network, X-Windows freezes.  No 
screen updates, the mouse cursor won't move, for all intents and purposes the 
system has frozen solid.  I'm playing music with XMMS2 and that keeps going, 
but occasionally even that stops too.  After a minute (between 45 and 65 
seconds) everything unfreezes and keeps going as per normal.  Less than 10 
seconds later everything freezes again for another minute!  This keeps going 
until the file transfer has finished.

When things unfreeze the disk is idle, and within 10 seconds the disk starts 
up again and almost immediately the next minute-long freeze begins.  While 
things are frozen the network transfer continues, and bizarrely I can log in 
to the machine over SSH where everything seems normal.  'top' reports most 
processes are idle, and running a command line XMMS2 client happily reports 
that the song I am listening to is stuck at exactly the same point until the 
freeze is over, when the seconds start counting up again.

The reason I am stuck is that nothing is appearing in dmesg, so it appears the 
kernel is unaware of the problem.  Has anyone seen anything like this before? 
  I'm not sure what to do next.

Disks are connected to an Intel ICH9 SATA controller in AHCI mode, LAN is a 
Realtek 8169, video card is nVidia GeForce 8600.  Perhaps some combination of 
this is to blame?

I have tried using cat to read these files into /dev/null and the system will 
happily read the files at full speed without freezing, and I have used ttcp's 
speed test function to send data over the network at full speed, which also 
works without X11 freezing.  Doing this at the same time (reading from the 
disk and sending network traffic) also works fine without locking up, so it 
seems the problems only arise when NFS gets involved.

'mount' reports the options on the NFS share as:
   rw,user=adam,tcp,soft,intr,timeo=20,vers=3,addr=192.168.0.6

Any suggestions about what I can do next?

Many thanks,
Adam.

