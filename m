Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2G0C6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 22:58:17 -0400
Received: from matrix.voodoobox.net ([75.127.97.206]:44590 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2G0C6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 22:58:15 -0400
Message-ID: <1343355303.29938.5.camel@obelisk.thedillows.org>
Subject: Re: RAID extremely slow
From: David Dillow <dave@thedillows.org>
To: Kevin Ross <kevin@familyross.net>
Cc: Phil Turmel <philip@turmel.org>, linux-kernel@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
Date: Thu, 26 Jul 2012 22:15:03 -0400
In-Reply-To: <5010A386.4080209@familyross.net>
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org>
	 <5010A386.4080209@familyross.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 18:55 -0700, Kevin Ross wrote:
> On 07/25/2012 06:00 PM, Phil Turmel wrote:
> > Piles of small reads  scattered across multiple drives, and a
> > concentration of queued writes to /dev/sda.  What's on /dev/sda?
> > It's not a member of the raid, so it must be some other system task
> > involved.

> After rebooting, MythTV is currently recording two shows, and the resync 
> is running at full speed.
> 
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdh1[0] sdd1[9] sde1[10] sdb1[6] sdi1[7] sdc1[4] 
> sdf1[3] sdg1[8] sdj1[1]
>        6837311488 blocks super 1.2 level 6, 512k chunk, algorithm 2 
> [9/9] [UUUUUUUUU]
>        [=>...................]  resync =  9.3% (91363840/976758784) 
> finish=1434.3min speed=10287K/sec
> 
> unused devices: <none>
> 
> atop shows the avio of all the drives to be less than 1ms, where before 
> they were much higher.  It will run for a couple days under load just 
> fine, and then it will come to a halt.
> 
> It's a 3.2.21 kernel.  I'm running Debian Testing, and the exact Debian 
> package version is:

I suspect you are being hit by same bug I was -- delayed stripes never
got processed. If you get into the state where the rebuild isn't
progressing, and you find that increasing the size of the stripe cache
allows the rebuild to proceed (but the filesystem stays wedged), then
that cinches it.

If you can, upgrade to the latest 3.4 stable kernel (3.4.6 right now).
As far as I can see, the latest 3.2 stable does not contain the delayed
stripe fix.

After applying those fixes to my kernel, my MythTV setup over a 5 disk
RAID5 has been pretty solid, where before I was getting lockups every
few days. It still seems to be getting slower over time, but I've not
looked into it yet as it is not as catastrophic as the wedging.

HTH,
Dave

