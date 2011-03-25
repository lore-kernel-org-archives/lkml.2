Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1CYL7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:59:09 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:57936 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617Ab1CYL7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:59:08 -0400
X-AuditID: 12074425-b7be5ae000000a16-2e-4d8c838d300c
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110325044128.GJ26611@dastard>
Date: Fri, 25 Mar 2011 07:59:00 -0400
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Content-Transfer-Encoding: 7bit
Message-Id: <91CCAB14-F9CC-4676-94C3-FBCDD0663FD5@mit.edu>
References: <4D8B4A89.80608@fusionio.com> <20110324183019.GA1676@gentoo.trippels.de> <4D8B8F34.5000203@fusionio.com> <4D8B92AE.8090308@fusionio.com> <20110324185445.GB1696@gentoo.trippels.de> <4D8B9457.2020608@fusionio.com> <20110324193441.GA1723@gentoo.trippels.de> <20110325044128.GJ26611@dastard>
To: Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsUixG6nrtvb3ONrsOOykEXvqZdsFluO3WO0
	mLbiDYvF5V1z2Cz+/7/NZPGo7y27A5vHqUUSHk+afjJ7nJjxm8Xj49NbLB79uy4weXzeJBfA
	FsVlk5Kak1mWWqRvl8CVMf9xI3vBS6GKmb1X2BsYb/N1MXJwSAiYSLx5E9HFyAlkiklcuLee
	rYuRi0NIYB+jxKa1CxkhnA2MEn83nWWCcE4zSdw9288M0iIs4CSx4eBHJpBJvAKGEqsuBIGE
	mQW0JG78e8kEYrMJKEnc+bSfBcTmFNCVWL93IyuIzSKgKnHx7QKwBcwC3UwShxd3sUA0y0ts
	fzsHbD6vgJXE8c9dUFesZpL4ee8oI0hCREBNYtKkHcwQd8tKzFo2jX0Co+AshDtmIbljFpKx
	CxiZVzHKpuRW6eYmZuYUpybrFicn5uWlFula6OVmluilppRuYgRHg4vqDsYJh5QOMQpwMCrx
	8LJM6PYVYk0sK67MPcQoycGkJMqrUd/jK8SXlJ9SmZFYnBFfVJqTWnyIUYKDWUmEdzELUI43
	JbGyKrUoHyYlzcGiJM47X1LdV0ggPbEkNTs1tSC1CCYrw8GhJMH7oQmoUbAoNT21Ii0zpwQh
	zcTBCTKcB2j4h0aQ4cUFibnFmekQ+VOMilLivJ9BmgVAEhmleXC9sGT1ilEc6BVh3hsgVTzA
	RAfX/QpoMBPQYPOEbpDBJYkIKakGRlWPd1qPOh8yCNqk9jZtaOcoWL/+xpJbIaZSUXnL3x2x
	3Fod+9in7DHXg/75++rKvoheKN7H4WVhckruS8/B2JqatWo+df9XTNumYXbqEy9zj8Hh0z5q
	T/d0qbPumDc/Yt2OmfuK6hVN5vAuXHPirWm+Zsa118vmvJxpl6GWuMhJh/O16HeBh0osxRmJ
	hlrMRcWJAIhXw5cxAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 25, 2011, at 12:41 AM, Dave Chinner wrote:

>> 
>> It works insofar as the Oops is gone. But my xfs partitions apparently
>> still get corrupted (I had to run xfs_repair on several of them, because
>> they would not mount otherwise).
> 
> So the patchset is causing repeatable filesystem corruption? Sounds
> to me like this series is not yet ready for mainline merging. Last
> thing I want to spend the .39 cycle helping people recover busted
> filesystems as a result of undercooked block layer changes...

FYI.   I did a trial merge last night of the ext4 changes last night with
the tip of Linus's tree.   The ext4 changes (based on 2.6.38-rc5) 
survived xfstests -g auto before I merged in Linus's 2.6.39 master
branch.  After I merged with 2.6.39-tip, I reran xfstests, and it got 
past test #13 (fsstress), which normally means that everything is
OK, so I sent a pull request to Linus.    Much later, (-g auto takes a 
long time) I got an OOPS inside the virtio driver.   Ext4 was nowhere 
in the stack trace, but of course the block layer was.   Grumbling
that someone  had broke virtio during the merge window, I switched
my KVM setup to use SATA emulation and used the sda devices
instead.  This time I got an oops in the block I/O layer, again quite
late in xfstests.  Somewhere around test #224 or so if I remember
correctly.

It was too late last night to do any more investigating, which is why
I hadn't sent a formal report yet, but next up is for me to retry xfstests
before merging in my changes, and then to start a git bisect.

So before accusing some patch series which hasn't been merged
into 2.6.39 yet, you might want to also worry about some change
that already has been merged.   Of course the symptoms for me are
quite different.   I'm not seeing an early oops, but only something
which shows up when the the system is put under a lot of stress
by xfstests.  So it could be a different problem....

								- Ted

P.S.  And of course there is the chance that there is some
subtle bug in the ext4 branch, which worked just fine when
it was just based on 2.6.38-rc5, but which only manifested
itself when I merged in the tip of Linus's branch.   So I'm not
__accusing__ the block layer yet, even though the stack traces
seem to point that way, because I don't have a smoking gun
yet.   But I do have to admit I'm suspicious....


