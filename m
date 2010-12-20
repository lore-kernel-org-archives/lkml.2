Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab0LTS1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:27:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41029 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab0LTS1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:27:40 -0500
Message-ID: <4D0FA098.8000405@kernel.org>
Date: Mon, 20 Dec 2010 10:29:44 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ftpadmin@kernel.org
Subject: Re: linux-next: Tree for December 20
References: <AANLkTi=gjHyMt=W4-+PSMzt7PN7i-_Yvmx7EE8z0z74q@mail.gmail.com>	<20101220230007.e82487b8.sfr@canb.auug.org.au> <AANLkTin4dvM1B8GkxZH6DADJVg4ZWNSQvUHAviy-4O2J@mail.gmail.com>
In-Reply-To: <AANLkTin4dvM1B8GkxZH6DADJVg4ZWNSQvUHAviy-4O2J@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Mon, 20 Dec 2010 10:27:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 04:12 AM, Sedat Dilek wrote:
> On Mon, Dec 20, 2010 at 1:00 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi,
>>
>> On Mon, 20 Dec 2010 12:46:08 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>
>>>>
>>>> [The mirroring on kernel.org is running slowly]
>>>
>>> Indeed, you know what's wrong with the mirrors?
>>
>> I don't know what is wrong.  The mirroring just seems to be much slower
>> in the last week or so.  Today, it was just over three hours from when I
>> uploaded linux-next until it was mirrored out.
>>
>> I have cc'd the admins.
>>
> 
> Thanks.

Gingerbread released last week, loads have been spiking to well above
300 on the frontend machines, RAM usage has been in the ~20G range (on
machines with 16G of RAM), and we've been running an *AVERAGE* of 2000+
simultaneous GIT processes worldwide (normal is in the 100-200 range).

Bonus points that we blew a drive on one of the machines yesterday.

I don't think anyone was quite expecting the onslaught we have gotten
this time around, and I'm going to have to make some changes before the
next big release (mainly shifting Android over to the bigger machines)

>>> Can you upload the diff-patch (patch-v2.6.37-rc6-next-20101220) to [1]
>>> from your local-tree or place it somewhere else?
>>
>> I cannot upload directly to www.kernel.org, I up load to the same place
>> on master.kernel.org and the mirroring system puts it on www.kernel.org.
>>
> 
> I could download the diff-patch.
> 
> $ wget http://www.kernel.org/pub/linux/kernel/v2.6/next/patch-v2.6.37-rc6-next-20101220.bz2

Running a quick set of stats against the logs we keep from the syncing
I'm seeing:

	All of December:
	------------------
	Number of cycles: 5848
	Total amount of time spent syncing: 1544407sec
	Average Sync times: 264sec
	Longest time: 24011sec
	Shortest time: 42sec

	Last 10 days:
	------------------
	Number of cycles: 2144
	Total amount of time spent syncing: 845762sec
	Average Sync times: 394sec
	Longest time: 24011sec
	Shortest time: 45sec

With cyclical patterns of fast and slow syncs.  We seem to be (right
now) in the middle of one of the slow cycles with the last few syncs
taking a couple of hours each.  The culprit, for at least the current
sync, seems to be the box with the highest load and the blown drive,
which I'm also reluctant to disable since it's still handling it's fair
share of the load and dumping all of that onto the opposite US mirror
would not be good either.

- John 'Warthog9' Hawley
