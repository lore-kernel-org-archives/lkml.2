Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1IKKQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 06:16:08 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60403 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1IKKQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 06:16:01 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Sep 2011 06:16:01 EDT
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-fsdevel@vger.kernel.org
Subject: graceful handling of removing a plugable storage device that is being written to
Date: Sun, 11 Sep 2011 12:08:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109111208.25761.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc to BTRFS mailinglist as it triggered the idea of mine again.


Hi!

Today I did it again and removed a BTRFS partition that is written too. 
That BTRFS as of Kernel 3.0.3 (debian package) does not like very much. I 
think thats a known issue and I wrote a mail to BTRFS mailing list about 
it.

In there I wrote:

> Expected results:
> 
> BTRFS fails gracefully except the loss of data from writes in flight, the 
> machine remains usable and BTRFS can be mounted again.

And then cause the expected results IMHO are by no way the ideal results:


> Ideal results (IMHO):
> 
> Linux behaved like AmigaOS and told me that I *must* insert the device 
> again and *continues* writing after I did this. 

But I never saw any other OS that did that.

And I see the problems with high bandwidth writes piling up in memory 
causing severe memory pressure.

But then could Linux just freeze processes that continue writing to the 
drive until it is replugged again? Of course that shouldn´t happen to the 
drive / resides on.

And there is a userspace part in it - the possibly udev and dbus  driven 
notification to the user.

Yet despite all of this NetBSD has a gsoc 2011 project at least suggested 
for exactly this behavior:

Graceful USB disk detach/reattach
http://wiki.netbsd.org/projects/gsoc_2011/disk-removal/

They even mention the Amiga in there.

Okay, its only for USB, not for eSATA, but I think it should be made 
generic for removable devices.

Would that be possible? I gladly file an enhancement request about it or 
help testing it.

I think thats the only approach that makes sense here. USB sticks and 
harddisks have no means to disallow device removal at any time. Thus the 
OS should offer the user a way to rethink the decision and plug the device 
in to prevent data loss. Actually I am surprised that no other operating 
system except AmigaOS seemed to offer this behavior. Well I am not quite 
sure about MS-DOS writing to disk. Maybe it even did that. But I did not 
use MS-DOS often. 

All current mainstream operating systems I know of default to loose data 
in that case. I think there is a better choice. What do you think? Might 
not be much of a server feature, but important for the desktop.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
