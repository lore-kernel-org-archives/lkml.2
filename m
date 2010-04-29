Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab0D3SaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:30:12 -0400
Received: from lo.gmane.org ([80.91.229.12]:49034 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779Ab0D3S1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:27:38 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: Request For Help - Embedded x86, Kernel 2.6.33 boots, Mounts ?JFFS2 rootfs, Stops at init
Date: Thu, 29 Apr 2010 09:01:46 +0100
Message-ID: <a0rna7-rem.ln1@chipmunk.wormnet.eu>
References: <4BD8415C.9060409@gmail.com> <s91ma7-76h.ln1@chipmunk.wormnet.eu> <y2zd66caabb1004281614qe5af7fa7i6d9d5ac957ea6520@mail.gmail.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graeme Russ <graeme.russ@gmail.com> wrote:
>
> On Thu, Apr 29, 2010 at 1:37 AM, Alexander Clouter <alex@digriz.org.uk> wrote:
>
>> What does you /dev directory look like?  You need to have at least the
>> following:
>> ----
>> mknod console c 5 1
>> mknod null c 1 3
>> mknod ttyS0 c 4 64
>> ----
> 
> tick, tick, tick
> 
> A little further background (should have included this last night but it
> was late and I thought the problem must be trivial)...
> 
> I had originally mounted this root fs using NFS with (very) limited
> success. After mounting and performing a few NFS requests (observed using
> wireshark) the NFS activity would simply stop with 'server not responding'
> messages. I turned on debugging in the 8139too and NFS drivers. With
> debugging output enabled I was still getting 'server not responding'
> messages, but (eventually) the boot sequence would continue. This even
> resulted in logs in /var/log of the NFS share for the device (filled with
> raw network packet data).
>
I got this behaviour when setting up a PXE booting workstation network 
registration system.  My issue was that the IP changed and was running
running TCP based NFS; I think the kernel continues to try to use the 
old IP, same socket, but as it is no longer there...Game Over.   
Depending on how your boot up worked, at the PXE booting phase (or 
just where the kernel uses DHCP to get a lease) things work, however 
then you get to the network configuring part of the boot up, dhclient 
uses a different identifier so you get a different IP.
 
Well...that's what happened to us and the simpliest fix was to move to 
UDP for NFS.

> But no console...
>
...instead of LFS, have you looked at buildroot[1]?

> What if I init with the following:
> 
> #!/bin/bash
> echo hello > /hello.txt
> 
....put a 'while (true); do sleep 1; done' on the end of that.  Although 
you should see a 'attempted to kill init' without it there.

> and then rebooted and checked the root fs in U-Boot? How long will it
> take for hello.txt to be flushed? Can I force the flush?
> 
Have a look at:

http://www.spinics.net/lists/mips/msg37361.html

Especially my 'readelf' bit, I'm guessing you might have forgotten a 
library or two in your keenness to trim your root mountpoint.

Cheers

[1] http://buildroot.uclibc.org/

-- 
Alexander Clouter
.sigmonster says: Time to be aggressive.  Go after a tattooed Virgo.

