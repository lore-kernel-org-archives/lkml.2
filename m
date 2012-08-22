Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989Ab2HVEAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:00:30 -0400
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:54565 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2HVD76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 23:59:58 -0400
Message-ID: <5034593F.8010806@hardwarefreak.com>
Date: Tue, 21 Aug 2012 22:59:59 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Miquel van Smoorenburg <mikevs@xs4all.net>
CC: David Brown <david.brown@hesbynett.no>, Michael Tokarev <mjt@tls.msk.ru>,
        Linux RAID <linux-raid@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT to md raid 6 is slow
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com> <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com> <502E2817.8040306@xs4all.net> <502F237D.6060806@hardwarefreak.com> <502F698C.9010507@msgid.tls.msk.ru> <50305AB9.5080302@hardwarefreak.com> <5030F1C6.90205@hesbynett.no> <50317804.9010701@hardwarefreak.com> <5033A06B.30508@xs4all.net>
In-Reply-To: <5033A06B.30508@xs4all.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2012 9:51 AM, Miquel van Smoorenburg wrote:
> On 08/20/2012 01:34 AM, Stan Hoeppner wrote:
>> I'm glad you jumped in David.  You made a critical statement of fact
>> below which clears some things up.  If you had stated it early on,
>> before Miquel stole the thread and moved it to LKML proper, it would
>> have short circuited a lot of this discussion.  Which is:
> 
> I'm sorry about that, that's because of the software that I use to
> follow most mailinglist. I didn't notice that the discussion was cc'ed
> to both lkml and l-r. I should fix that.

Oh, my bad.  I thought it was intentional.

Don't feel too bad about it.  When I tried to copy lkml back in on the
one message I screwed up as well.  I though Tbird had filled in the full
address but it didn't.

>> Thus my original statement was correct, or at least half correct[1], as
>> it pertained to md/RAID6.  Then Miquel switched the discussion to
>> md/RAID5 and stated I was all wet.  I wasn't, and neither was Dave
>> Chinner.  I was simply unaware of this md/RAID5 single block write RMW
>> shortcut
> 
> Well, all I tried to say is that a small write of, say, 4K, to a
> raid5/raid6 array does not need to re-write the whole stripe (i.e.
> chunksize * nr_disks) but just 4K * nr_disks, or the RMW variant of that.

And I'm glad you did.  Before that I didn't know about these efficiency
shortcuts and exactly how md does writeback on partial stripe updates.

Even with these optimizations, a default 512KB chunk is too big, for the
reasons I stated, the big one being the fact that you'll rarely fill a
full stripe, meaning nearly every write will incur an RMW cycle.

-- 
Stan

