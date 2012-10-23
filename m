Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab2JWAH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:07:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58637 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab2JWAH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:07:27 -0400
Date: Tue, 23 Oct 2012 02:07:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sooman Jeong <77smart@hanyang.ac.kr>
Cc: linux-kernel@vger.kernel.org, Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: Initial report on F2FS filesystem performance
Message-ID: <20121023000725.GA10990@elf.ucw.cz>
References: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>
 <20121020192215.GB555@elf.ucw.cz>
 <E0328919-ACAA-4052-B922-952AFA375FD8@dubeyko.com>
 <20121021102638.GA14031@elf.ucw.cz>
 <1350905803450.1936.166.00.1.77smart@hanyang.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350905803450.1936.166.00.1.77smart@hanyang.ac.kr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> As requested, I compared performance of VFAT with f2fs on SD card.
> Following is summary of the measurement.

Thanks.

> VFAT shows better performance on both random write+fsync and buffered-sequential write than f2fs.
> However, on buffered-random and sequential write+fsync, f2fs still exhibits better performance 
> than other filesystems.
> 
> 
> * buffered write (1GB file), 4KByte write
> ------------------------------------------------------------------------------
>                      Desktop PC                         Galaxy-S3
> ------------------------------------------------------------------------------
>          sequential (MB/s)  random (IOPS)  sequential (MB/s)   random (IOPS)  
> ------------------------------------------------------------------------------
...
>   F2FS          10.6            2675               6.9             1682      
>   VFAT           7.3            1108               7.3             1075               
> ------------------------------------------------------------------------------

Ok, f2fs is bit faster on desktop PC and a bit slower on S3. Good.


> * write + fsync (100MB file), 4KByte write
> ------------------------------------------------------------------------------
>                      Desktop PC                         Galaxy-S3
> ------------------------------------------------------------------------------
>          sequential (KB/s)  random (IOPS)  sequential (KB/s)   random (IOPS)  
> ------------------------------------------------------------------------------
>   F2FS         1057.9            240              772.3             184
>   VFAT          356.5            260              474.4             373
> ------------------------------------------------------------------------------

Ok, random access on VFAT is a lot faster on S3 (and only very
a bit on PC). Any idea why results are so different between PC and S3?
Does F2FS need significantly more CPU? Does F2FS need significantly
more RAM? (Booting PC with low mem= option my answer that).

Anyway, it looks like F2FS is pretty fast filesystem...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
