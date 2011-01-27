Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1A0BW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:22:28 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:29979 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754257Ab1A0BW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:22:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAMNXQE1Ld/sX/2dsb2JhbAAMhAbNPJBogSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,383,1291611600"; 
   d="scan'208";a="89369819"
Message-ID: <4D40C8D1.8090202@teksavvy.com>
Date: Wed, 26 Jan 2011 20:22:25 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: xfs: very slow after mount, very slow at umount
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex / Christoph,

My mythtv box here uses XFS on a 2TB drive for storing recordings and videos.
It is behaving rather strangely though, and has gotten worse recently.
Here is what I see happening:

The drive mounts fine at boot, but the very first attempt to write a new file
to the filesystem suffers from a very very long pause, 30-60 seconds, during which
time the disk activity light is fully "on".

This happens only on the first new file write after mounting.
>From then on, the filesystem is fast and responsive as expected.
If I umount the filesystem, and then mount it again,
the exact same behaviour can be observed.

This of course screws up mythtv, as it causes me to lose the first 30-60
seconds of the first recording it attempts after booting.  So as a workaround
I now have a startup script to create, sync, and delete a 64MB file before
starting mythtv.  This still takes 30-60 seconds, but it all happens and
finishes before mythtv has a real-time need to write to the filesystem.

The 2TB drive is fine -- zero errors, no events in the SMART logs,
and I've disabled the silly WD head-unload logic on it.

What's happening here?  Why the big long burst of activity?
I've only just noticed this behaviour in the past few weeks,
running 2.6.35 and more recently 2.6.37.

* * *

The other issue is something I notice at umount time.
I have a second big drive used as a backup device for the drive discussed above.
I use "mirrordir" (similar to rsync) to clone directories/files from the main
drive to the backup drive.  After mirrordir finishes, I then "umount /backup".
The umount promptly hangs, disk light on solid, for 30-60 seconds, then finishes.

If I type "sync" just before doing the umount, sync takes about 1 second,
and the umount finishes instantly.

Huh? What's happening there?

System is running 2.6.37 from kernel.org, but similar behaviour
has been there under 2.6.35 and 2.6.34.  Dunno about earlier.

I can query any info you need from the filesystem.

Thanks
-ml
