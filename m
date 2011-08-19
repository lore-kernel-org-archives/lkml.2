Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1HSWmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:42:07 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:38486 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1HSWmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:42:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 0/3] make ntfs_free() NULL safe
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <alpine.LNX.2.00.1108200007520.31857@swampdragon.chaosbits.net>
Date: Fri, 19 Aug 2011 23:42:02 +0100
Cc: linux-kernel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
Content-Transfer-Encoding: 8BIT
Message-Id: <3FD00282-F6B7-443A-B019-DBBEF75E86E6@tuxera.com>
References: <alpine.LNX.2.00.1108192321130.31857@swampdragon.chaosbits.net> <39DAF2CE-95BC-4E0C-B30E-4686DF0E8D31@tuxera.com> <alpine.LNX.2.00.1108200007520.31857@swampdragon.chaosbits.net>
To: Jesper Juhl <jj@chaosbits.net>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 19 Aug 2011, at 23:21, Jesper Juhl wrote:
> On Fri, 19 Aug 2011, Anton Altaparmakov wrote:
>> On 19 Aug 2011, at 22:30, Jesper Juhl wrote:
>>> Here's a small series of patches that make it safe to call ntfs_free() 
>>> with a NULL pointer and reaps some bennefits from that.
>>> 
>>> The first patch in the series simply makes ntfs_free() safe to call with a 
>>> NULL pointer. This fits with many other kernel freeing functions, that are 
>>> generally safe to call with NULL pointers.
>>> 
>>> The second patch adds some documentation to ntfs_free() similar to what's 
>>> already provided for the allocation functions.  ntfs_free() is fairly 
>>> simple so you could argue that such documentation is not really needed, 
>>> but I say it's still nice to have if for no other reason than 
>>> completeness.
>>> 
>>> The third patch removes a number of tests for NULL pointers before calls 
>>> to ntfs_free() that patch 1 make redundant.
>> 
>> Patches look fine.  Feel free to add my
>> 
>> 	Acked-by: Anton Altaparmakov <anton@tuxera.com>
>> 
> Thank you.
> 
>> and to send them to Linus for inclusion…
>> 
> I think I'll wait a bit before doing that. Hopefully some maintainer will 
> pick them up and push them. But if that doesn't happen I'll make sure to 
> re-sumbit them myself and point them higher up the hierarchy (with your 
> ACK attached) :-)

Ok, thanks.  I have no other changes for NTFS so no point in me taking them to submit to Linus, you might as well do it yourself (and I am incredibly busy at the moment).  (-:

>>> This whole things came about because Coverity Prevent spotted that in 
>>> fs/ntfs/runlist.c on line 967 we call ntfs_runlists_merge() which frees 
>>> its second argument and we then explicitly free that argument via 
>>> ntfs_free() again on line 970. This patch series also makes that a non 
>>> issue.
>> 
>> Ah but Coverity Prevent is incorrect in its spotting!
>> 
>> Have a look yourself!
>> 
>> ntfs_runlists_merge() _ONLY_ frees its second argument if it returns success.  If it returns error it does _NOT_ free its second argument!
>> 
> On second inspection I believe you are right.

(-:

>> And line 970 is _ONLY_ executed if ntfs_runlists_merge() returned error, i.e. in the case that the second argument was _NOT_ freed.  If the argument was freed, ntfs_runlists_merge() would have returned success, and then line 970 would never have been reached…
>> 
>> So I am afraid this is a bug in Coverity Prevent rather than in NTFS.  (-:
>> 
> I'll make a note in prevent that this is a false positive.
> 
> I still believe the 3 patches make sense though, regardless of this.

Indeed, that is why you got my ACK for them…  (-:

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

