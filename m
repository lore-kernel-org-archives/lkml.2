Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1BLOLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 09:11:11 -0500
Received: from in.cluded.net ([195.159.98.120]:39724 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1BLOLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 09:11:08 -0500
Message-ID: <4D5693E7.2010000@uw.no>
Date: Sat, 12 Feb 2011 14:06:31 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: "Daniel K." <dk@uw.no>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md: Remove risk of overflow via sprintf) by using snprintf()
 in md_check_recovery()
References: <alpine.LNX.2.00.1102112227040.16994@swampdragon.chaosbits.net> <4D56541D.3030409@uw.no> <4D568FCA.90902@msgid.tls.msk.ru>
In-Reply-To: <4D568FCA.90902@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> 12.02.2011 12:34, Daniel K. wrote:
>> Jesper Juhl wrote:
>>> sprintf() is dangerous - given the wrong source string it will
>>> overflow the destination. snprintf() is safer in that at least we'll
>>> never overflow the destination. Even if overflow will never happen
>>> today, code changes over time and snprintf() is just safer in the long
>>> run.
>>> -                        sprintf(nm,"rd%d", rdev->raid_disk);
>>> +                        snprintf(nm, sizeof(nm), "rd%d", rdev->raid_disk);
>>>                          sysfs_remove_link(&mddev->kobj, nm);
>> What if "rd1234" get truncated to "rd123" and you remove the wrong link.
>> (No, I didn't actually bother to check how much room was allocated.)
> 
> That allocation is in the line above first sprintf which you deleted.
> Sure, didn't bother, it's very difficult.

Yeah, early morning, I cut to much, and I didn't bother to look it up 
again, sorry for being lazy. Nevertheless, the actual size is of the 
allocation is of no particular importance. As you've shown, the current 
allocation of 20 bytes is more than enough.

> C'mon guys, this is pointless.  20 bytes allocated for the device
> name, and this is for raid disk number.  It is impossible to have
> more than 10^17 (20 bytes total, 2 for "rd" and on for the zero
> terminator) drives in a single array.

Agreed, and this was sort of the point.

In all probability it would not overflow, and if it did, it would be 
better for it to crash and burn, than to unlink the wrong files.


Daniel K.
