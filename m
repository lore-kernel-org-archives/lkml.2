Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1FRKi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 06:38:28 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:49152 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1FRKi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 06:38:27 -0400
Subject: Re: [Bug 37682] New: Kernel mis-detects size/position of partition
 created with Seagate DiscWizard (OnTrack Disk Manager)
From: Paul Bolle <pebolle@tiscali.nl>
To: markk@clara.co.uk
Cc: Andrew Morton <akpm@linux-foundation.org>,
        bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <c6813b0914dd61da40fc2db868ea5b11.squirrel@ssl-webmail-vh.clara.net>
References: <bug-37682-10286@https.bugzilla.kernel.org/>
	 <20110617143104.3b883bda.akpm@linux-foundation.org>
	 <1308359856.2166.23.camel@t41.thuisdomein>
	 <c6813b0914dd61da40fc2db868ea5b11.squirrel@ssl-webmail-vh.clara.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Jun 2011 12:38:21 +0200
Message-ID: <1308393501.23584.27.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-18 at 09:51 +0100, markk@clara.co.uk wrote:
> Paul Bolle wrote:
> > That was 232595eaff951e96cabe5e85fed35f66b72ff51e ("ide: remove
> > obsoleted "hdx=" kernel parameters"), which was applied in the v2.6.27
> > cycle.
> 
> Was the feature which that commit removed specific to ide devices? That
> is, would it have not applied for a drive connected via a USB/Firewire
> bridge?

I have no clue. I'd guess it wouldn't. For instance, a drive connected
using USB uses the SCSI layer, doesn't it? That wasn't different a few
years ago.

> Ideally the kernel partition-scanning code would be fixed to handle these
> strange partitions. As a temporary measure, it might be best to print a
> warning and not create the incorrect block device.
> 
> E.g. user might think "I'll back up this partition"
>   dd if=/dev/sdc1 of=partition.bin
> or "I'll wipe this partition before disposing of the disk"
>   dd if=/dev/zero of=/dev/sdc1.
> Neither has the desired effect.

Digging further into this I found commit d708c40d ("ide: mark
"hdx=remap" and "hdx=remap63" kernel parameters as obsoleted"). The
commit message reads:
    Mark "hdx=remap" and "hdx=remap63" kernel parameters as obsoleted
    (they are layering violation and should be dealt with in the same
    way as done by libata - device-mapper should be used instead).

Perhaps this means one is expected to use dmsetup(8) for this. I have
never configured device-mapper at that level by hand. man 8 dmsetup is
over 300 lines of (new for me) information. Without a disk like yours at
hand, it's hard to say whether device-mapper allows to do stuff like
this (ie, remapping an entire drive by 63 sectors) by hand.

Of course, for your particular drive it might be easier to just dd the
actual partition (so skipping 63 sectors) into new file (a 20G image) on
another drive. That image should be loop mountable. If that's correct
you could then do with the drive as you please. Given its age, it may be
wise to, say, shred(1) its corresponding device and drop the drive at
your local recycling site.


Paul Bolle

