Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab1FIX0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:26:14 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:57237 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab1FIX0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:26:11 -0400
X-Greylist: delayed 1649 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jun 2011 19:26:11 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <1307650642.9874.10.camel@tucsk.pomaz.szeredi.hu>
Date: Thu, 9 Jun 2011 23:58:37 +0100
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@openwrt.org, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
Content-Transfer-Encoding: 8BIT
Message-Id: <EE48B29B-EC3F-44D7-9A39-07F6EA138AC4@cam.ac.uk>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown> <20110608205233.ebfedc4d.akpm@linux-foundation.org> <20110609134947.GD13242@shadowen.org> <20110609123220.6afb9d0f.akpm@linux-foundation.org> <BANLkTimTyYp1P4qd8awvsq6PVZn1TQ5A-Q@mail.gmail.com> <1307650642.9874.10.camel@tucsk.pomaz.szeredi.hu>
To: Miklos Szeredi <mszeredi@suse.cz>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 9 Jun 2011, at 21:17, Miklos Szeredi wrote:
> On Thu, 2011-06-09 at 12:40 -0700, Linus Torvalds wrote:
>> On Thu, Jun 9, 2011 at 12:32 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>> 
>>> If the implementation is slow or buggy then the appropriate action is
>>> to speed it up and to fix the bugs, so these are just non-arguments,
>>> IMO.
>> 
>> Umm.
>> 
>> "userspace filesystem"?
>> 
>> The problem is right there. Always has been. People who think that
>> userspace filesystems are realistic for anything but toys are just
>> misguided.
>> 
>> fuse works fine if the thing being exported is some random low-use
>> interface to a fundamentally slow device. But for something like your
>> root filesystem? Nope. Not going to happen.
> 
> It's a tradeoff between speed and ease of development.
> 
> NTFS has been doing nicely in userspace for almost half a decade.  It's
> not as fast as a kernel driver _could_ be, but it's faster than _the_
> kernel driver.

Er, sorry to disappoint but the Tuxera NTFS kernel driver is faster than any user space NTFS driver could ever be.  It is faster than ext3/4, too.  (-:  To give you a random example on an embedded system (800MHz, 512MB RAM, 64kiB write buffer size) where NTFS in user space achieves a maximum cached write throughput of ~15MiB/s, ext3 achieves ~75MiB/s, ext4 ~100MiB/s and Tuxera NTFS kernel driver achieves ~190MiB/s blowing ext4 out of the water by almost a factor of 2 and the user space code by more than a factor of 10.  File systems in user space have their applications but high performance is definitely not one of them...  You might say that ext3/4 are journalling so not a fair comparison so let me add that FAT32 achieves about 100MiB/s in the same hardware/test, still about half of NTFS.

Only problem is that Tuxera NTFS is not open source.  )-:  Hopefully one day it will be!!!

The big advantage of user space drivers is that you can compile a binary and it will run on a lot of installs and also it is hugely easier to port to other architectures like the multitude of embedded OS out there that are not Linux based.  With the kernel driver it has to be compiled for each and every kernel and .config of each customer which is a lot of work (even though it is scripted) and the work to port to other kernels is immense...

> And there's room for improvement.  The fact is (and you know it) the
> speed of filesystems mainly comes from caching not from the filesystem
> itself, so whether it's in userspace or in kernelspace matters not all
> that much in the end.

It does matter if nothing else because you cannot cache everything in user space that you can cache in the kernel, not with any sort of reliability anyway...

PS. Please note I have nothing against FUSE and user space file systems in general.  I think FUSE is brilliant and makes writing weird file systems a pleasurable experience!  I have myself used it to solve all sorts of problems.  (-:

Best regards,

	Anton

>> So Andrew, I think that arguing that something _can_ be done with
>> fuse, and thus _should_ be done with fuse is just ridiculous. That's
>> like saying you should do a microkernel - it may sound nice on paper,
>> but it's a damn stupid idea for people who care more about some idea
>> than they care about reality.
> 
> I think it isn't ridiculous, but here the tradeoffs might be in favor of
> a kernel based solution.  And I'm saying that after having done both.
> 
> Thanks,
> Miklos

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

