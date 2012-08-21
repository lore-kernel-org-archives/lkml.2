Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab2HUOv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:51:57 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2008 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab2HUOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:51:54 -0400
Message-ID: <5033A06B.30508@xs4all.net>
Date: Tue, 21 Aug 2012 16:51:23 +0200
From: Miquel van Smoorenburg <mikevs@xs4all.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: stan@hardwarefreak.com
CC: David Brown <david.brown@hesbynett.no>, Michael Tokarev <mjt@tls.msk.ru>,
        Linux RAID <linux-raid@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT to md raid 6 is slow
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com> <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com> <502E2817.8040306@xs4all.net> <502F237D.6060806@hardwarefreak.com> <502F698C.9010507@msgid.tls.msk.ru> <50305AB9.5080302@hardwarefreak.com> <5030F1C6.90205@hesbynett.no> <50317804.9010701@hardwarefreak.com>
In-Reply-To: <50317804.9010701@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 01:34 AM, Stan Hoeppner wrote:
> I'm glad you jumped in David.  You made a critical statement of fact
> below which clears some things up.  If you had stated it early on,
> before Miquel stole the thread and moved it to LKML proper, it would
> have short circuited a lot of this discussion.  Which is:

I'm sorry about that, that's because of the software that I use to 
follow most mailinglist. I didn't notice that the discussion was cc'ed 
to both lkml and l-r. I should fix that.

> Thus my original statement was correct, or at least half correct[1], as
> it pertained to md/RAID6.  Then Miquel switched the discussion to
> md/RAID5 and stated I was all wet.  I wasn't, and neither was Dave
> Chinner.  I was simply unaware of this md/RAID5 single block write RMW
> shortcut

Well, all I tried to say is that a small write of, say, 4K, to a 
raid5/raid6 array does not need to re-write the whole stripe (i.e. 
chunksize * nr_disks) but just 4K * nr_disks, or the RMW variant of that.

Mike.
