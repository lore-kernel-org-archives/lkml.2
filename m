Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2JWRLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:11:23 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:34933 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754731Ab2JWRLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:11:21 -0400
Subject: Re: Initial report on F2FS filesystem performance
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <20121023000725.GA10990@elf.ucw.cz>
Date: Tue, 23 Oct 2012 21:10:46 +0400
Cc: Sooman Jeong <77smart@hanyang.ac.kr>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <54B92072-C95C-404F-A058-CF77098855C4@dubeyko.com>
References: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr> <20121020192215.GB555@elf.ucw.cz> <E0328919-ACAA-4052-B922-952AFA375FD8@dubeyko.com> <20121021102638.GA14031@elf.ucw.cz> <1350905803450.1936.166.00.1.77smart@hanyang.ac.kr> <20121023000725.GA10990@elf.ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 23, 2012, at 4:07 AM, Pavel Machek wrote:

> Hi!
> 
>> As requested, I compared performance of VFAT with f2fs on SD card.
>> Following is summary of the measurement.
> 
> Thanks.
> 
>> VFAT shows better performance on both random write+fsync and buffered-sequential write than f2fs.
>> However, on buffered-random and sequential write+fsync, f2fs still exhibits better performance 
>> than other filesystems.
>> 
>> 
>> * buffered write (1GB file), 4KByte write
>> ------------------------------------------------------------------------------
>>                     Desktop PC                         Galaxy-S3
>> ------------------------------------------------------------------------------
>>         sequential (MB/s)  random (IOPS)  sequential (MB/s)   random (IOPS)  
>> ------------------------------------------------------------------------------
> ...
>>  F2FS          10.6            2675               6.9             1682      
>>  VFAT           7.3            1108               7.3             1075               
>> ------------------------------------------------------------------------------
> 
> Ok, f2fs is bit faster on desktop PC and a bit slower on S3. Good.
> 
> 
>> * write + fsync (100MB file), 4KByte write
>> ------------------------------------------------------------------------------
>>                     Desktop PC                         Galaxy-S3
>> ------------------------------------------------------------------------------
>>         sequential (KB/s)  random (IOPS)  sequential (KB/s)   random (IOPS)  
>> ------------------------------------------------------------------------------
>>  F2FS         1057.9            240              772.3             184
>>  VFAT          356.5            260              474.4             373
>> ------------------------------------------------------------------------------
> 
> Ok, random access on VFAT is a lot faster on S3 (and only very
> a bit on PC). Any idea why results are so different between PC and S3?
> Does F2FS need significantly more CPU? Does F2FS need significantly
> more RAM? (Booting PC with low mem= option my answer that).
> 

Yes, I think that f2fs really needs more CPU and memory for functioning. The f2fs keeps more metadata as VFAT, as I understand. Moreover, it manages six active logs at runtime and GC can works in background. All of it needs in more CPU power.

With the best regards,
Vyacheslav Dubeyko.

> Anyway, it looks like F2FS is pretty fast filesystem...
> 
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

